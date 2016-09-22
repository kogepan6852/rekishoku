'use strict'

###*
 # @ngdoc function
 # @name frontApp.controller:AboutCtrl
 # @description
 # # AboutCtrl
 # Controller of the frontApp
###
angular.module 'frontApp'
  .controller 'MapCtrl', ($scope, $rootScope, $window, $ionicSideMenuDelegate, $controller, $translate, Api, toaster, BaseService, Const, DataService, $state, $ionicNavBarDelegate, $ionicViewSwitcher) ->

    # Controllerの継承
    $controller 'BaseCtrl', $scope: $scope

    ###
    # setting
    ###
    $scope.$on '$ionicView.enter', (e) ->
      $rootScope.isHideTab = false

    DataService.getShopCategory (data) ->
      $scope.categories = data
    DataService.getPeriod (data) ->
      $scope.periods = data
    DataService.getPeople (data) ->
      $scope.people = data

    $scope.input = {
      address: null
    }
    $scope.isDragging = false;

    $ionicNavBarDelegate.showBackButton false

    # 初期位置の設定
    latitude = Const.MAP.CENTER.DEFAULT.LAT
    longitude = Const.MAP.CENTER.DEFAULT.LNG
    defaultZoom = Const.MAP.ZOOM.DEFAULT
    targetDistance = BaseService.calMapDistance(defaultZoom)

    if $rootScope.latitude & $rootScope.longitude
      latitude = $rootScope.latitude
      longitude = $rootScope.longitude
    if $rootScope.zoom
      defaultZoom = $rootScope.zoom

    # Google Mapの初期設定
    $scope.map =
      center:
        latitude: latitude
        longitude: longitude
      zoom: defaultZoom
      bounds: {}

    $scope.options =
      scrollwheel: false
      minZoom: Const.MAP.ZOOM.MIN
      disableDefaultUI: true
      zoomControl: true

    # Google Mapの各種イベント処理の設定
    $scope.events =
      dragstart: (cluster, clusterModels) ->
        $ionicSideMenuDelegate.canDragContent(false)
        $scope.isDragging = true;
      dragend: (cluster, clusterModels) ->
        $ionicSideMenuDelegate.canDragContent(true)
        obj =
          latitude: cluster.center.lat()
          longitude: cluster.center.lng()
          shopDistance: targetDistance
        # map表示用データの作成と設定
        setMapData(obj, false, false)
      zoom_changed: (cluster, clusterModels) ->
        $rootScope.zoom = cluster.zoom
        # GoogleMapの距離計算
        targetDistance = BaseService.calMapDistance(cluster.zoom)
        obj =
          latitude: cluster.center.lat()
          longitude: cluster.center.lng()
          shopDistance: targetDistance
        # map表示用データの作成と設定
        setMapData(obj, true, false)

    $scope.targetMarkers = []

    ###
    # initialize
    ###
    $scope.init = ->
      if $rootScope.zoom
        targetDistance = BaseService.calMapDistance($rootScope.zoom)
      if $rootScope.targetAddress
        $scope.input.address = $rootScope.targetAddress
        $scope.searchShops()
      else if $rootScope.latitude & $rootScope.longitude
        obj =
          latitude: $rootScope.latitude
          longitude: $rootScope.longitude
          shopDistance: targetDistance
        # map表示用データの作成と設定
        setMapData(obj, true, true)

      else
        # 現在地の取得
        $rootScope.current = null;
        if navigator.geolocation
          navigator.geolocation.getCurrentPosition ((position) ->
            # 現在地アイコン用
            $rootScope.current = {
              latitude: position.coords.latitude,
              longitude: position.coords.longitude
            };
            # MAP用
            $scope.map.center.latitude = position.coords.latitude
            $scope.map.center.longitude = position.coords.longitude

            obj =
              latitude: position.coords.latitude
              longitude: position.coords.longitude
              shopDistance: targetDistance
            # map表示用データの作成と設定
            setMapData(obj, true, true)

            ), (e) ->
              obj =
                latitude: Const.MAP.CENTER.DEFAULT.LAT
                longitude: Const.MAP.CENTER.DEFAULT.LNG
                shopDistance: targetDistance
              # map表示用データの作成と設定
              setMapData(obj, true, true)
              # エラー表示
              alert($translate.instant('MSG.ALERT.NO_POSITION'))
        else
          alert($translate.instant('MSG.ALERT.NO_POSITION'))

    ###
    # Common function
    ###
    setMapData = (obj, isLoading, isMove) ->
      # 検索ワードの設定
      searchData = $scope.getSearchData()
      obj.keywords = searchData.keywords
      obj.period = searchData.period
      obj.person = searchData.person
      obj.category = searchData.category
      obj.province = searchData.province

      # mapデータの取得
      getMapData = (latLng) ->
        if latLng
          obj.latitude = latLng.latitude
          obj.longitude = latLng.longitude

        $scope.map.center.latitude = obj.latitude
        $scope.map.center.longitude = obj.longitude
        $rootScope.latitude = obj.latitude
        $rootScope.longitude = obj.longitude

        Api.getJson(obj, Const.API.MAP, isLoading).then (resShops) ->
          # mapデータ設定
          $scope.isDragging = false
          $scope.currentIcon = []
          shops = []
          # 現在地アイコンの設定
          if $rootScope.current
            now =
              latitude: $rootScope.current.latitude,
              longitude: $rootScope.current.longitude,
              icon:
                url: '../images/current-pin.png'
                scaledSize : new google.maps.Size(35, 35)
            now['id'] = 0
            $scope.currentIcon.push(now)

          # map表示用データの作成
          angular.forEach resShops.data.shops, (shop, i) ->
            ret =
              latitude: shop.latitude,
              longitude: shop.longitude,
              title: shop.name
              url: shop.image.thumb.url
              icon:
                url: '../images/map-pin.png'
                scaledSize : new google.maps.Size(25, 35)
            ret['id'] = shop.id
            shops.push(ret)
          $scope.targetMarkers = shops

      # 住所検索の場合
      targetAddress = obj.province
      if targetAddress && isMove
        # map位置を移動して検索
        calLatLng targetAddress, getMapData
      else
        # そのまま検索
        getMapData()

    # 位置検索
    calLatLng = (address, callback) ->
      if !address
        return
      # 緯度経度の計算
      BaseService.getLatLng address, (latLng) ->
        obj =
          latitude: latLng.lat
          longitude: latLng.lng
          shopDistance: targetDistance

        callback obj

    ###
    # Global function
    ###
    $rootScope.mapSearch = ->
      $scope.search()

    ###
    # function
    ###
    # 検索処理
    $scope.search = ->
      # GoogleMapの距離計算
      obj =
        latitude: $rootScope.latitude
        longitude: $rootScope.longitude
        shopDistance: targetDistance

      # map表示用データの作成と設定
      setMapData(obj, true, true)

    # 店舗検索
    $scope.searchShops = ->
      if !$scope.input.address
        return
      # 緯度経度の計算
      BaseService.getLatLng $scope.input.address, (latLng) ->
        obj =
          latitude: latLng.lat
          longitude: latLng.lng
          shopDistance: targetDistance
        # map表示用データの作成と設定
        setMapData(obj, true)

    # 現在地への移動
    $scope.moveToCurrentPlace = ->
      $rootScope.targetAddress = null
      $rootScope.latitude = null
      $rootScope.longitude = null
      $scope.init()
