'use strict'

###*
 # @ngdoc function
 # @name frontApp.controller:AboutCtrl
 # @description
 # # AboutCtrl
 # Controller of the frontApp
###
angular.module 'frontApp'
  .controller 'MapCtrl', ($scope, $rootScope, $window, $ionicSideMenuDelegate, $translate, Api, toaster, BaseService, Const) ->

    # 変数設定
    $rootScope.appTitle = $translate.instant('SEO.TITLE.MAP')
    $rootScope.isHideTab = false
    $scope.input = {
      address: null
    }
    $scope.isDragging = false;

    # 初期位置の設定
    latitude = 35.6813818
    longitude = 139.7660838
    defaultZoom = 14
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
      minZoom: 11
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
        setMapData(obj, false)
      zoom_changed: (cluster, clusterModels) ->
        $rootScope.zoom = cluster.zoom
        # GoogleMapの距離計算
        targetDistance = BaseService.calMapDistance(cluster.zoom)
        obj =
          latitude: cluster.center.lat()
          longitude: cluster.center.lng()
          shopDistance: targetDistance
        # map表示用データの作成と設定
        setMapData(obj, true)

    $scope.targetMarkers = []

    # 初期処理
    $scope.init = ->
      if $rootScope.targetAddress
        $scope.input.address = $rootScope.targetAddress
        $scope.searchShops()
      else if $rootScope.latitude & $rootScope.longitude
        obj =
          latitude: $rootScope.latitude
          longitude: $rootScope.longitude
          shopDistance: targetDistance
        # map表示用データの作成と設定
        setMapData(obj, true)

      else
        # 現在地の取得
        if navigator.geolocation
          navigator.geolocation.getCurrentPosition ((position) ->
            $scope.map.center.latitude = position.coords.latitude
            $scope.map.center.longitude = position.coords.longitude

            obj =
              latitude: position.coords.latitude
              longitude: position.coords.longitude
              shopDistance: targetDistance
            # map表示用データの作成と設定
            setMapData(obj, true)

            ), (e) ->
              if typeof e == 'string'
                alert(e)
              else
                alert(e.message)
        else
          alert($translate.instant('MSG.ALERT.NO_POSITION'))

    # Function
    # 店舗検索
    $scope.searchShops = ->
      # 緯度経度の計算
      BaseService.getLatLng $scope.input.address, (latLng) ->
        obj =
          latitude: latLng.lat
          longitude: latLng.lng
          shopDistance: targetDistance
        # map表示用データの作成と設定
        setMapData(obj, true)

    setMapData = (obj, isLoding) ->
      # 中心位置の設定
      $scope.map.center.latitude = obj.latitude
      $scope.map.center.longitude = obj.longitude
      $rootScope.latitude = obj.latitude
      $rootScope.longitude = obj.longitude

      Api.getJson(obj, Const.API.MAP, isLoding).then (resShops) ->
        # mapデータ設定
        $scope.isDragging = false;
        shops = []
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

    # 現在地への移動
    $scope.moveToCurrentPlace = ->
      $rootScope.targetAddress = null
      $rootScope.latitude = null
      $rootScope.longitude = null
      $scope.init()
