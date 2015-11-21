'use strict'

###*
 # @ngdoc function
 # @name frontApp.controller:AboutCtrl
 # @description
 # # AboutCtrl
 # Controller of the frontApp
###
angular.module 'frontApp'
  .controller 'MapCtrl', ($scope, $rootScope, $window, $sessionStorage, $ionicSideMenuDelegate, Api, toaster, BaseService, Const) ->

    # 変数設定
    $rootScope.isHideTab = false
    $scope.input = {
      address: null
    }
    $scope.isRefresh = true
    $scope.isDragging = false;

    defaultZoom = 14
    targetDistance = BaseService.calMapDistance(defaultZoom)

    # 初期位置の設定
    latitude = 35.6813818
    longitude = 139.7660838
    if $rootScope.latitude & $rootScope.longitude
      latitude = $rootScope.latitude
      longitude = $rootScope.longitude

    $scope.map =
      center:
        latitude: latitude
        longitude: longitude
      zoom: defaultZoom
      bounds: {}
    $scope.options =
      scrollwheel: false
      minZoom: 11

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
        # GoogleMapの距離計算
        targetDistance = BaseService.calMapDistance(cluster.zoom)
        obj =
          placeAddress: $scope.input.address
          shopDistance: targetDistance
        # map表示用データの作成と設定
        setMapData(obj, true)

    $scope.targetMarkers = []

    # 初期処理
    $scope.init = ->
      if $rootScope.targetAddress
        obj =
          placeAddress: $rootScope.targetAddress
          shopDistance: targetDistance
        # map表示用データの作成と設定
        setMapData(obj, true)

      # 現在地の取得
      else if navigator.geolocation
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
        alert('位置情報を取得できません。')

    # Function
    $scope.searchShops = ->
      obj =
        placeAddress: $scope.input.address
        shopDistance: targetDistance
      # map表示用データの作成と設定
      setMapData(obj, true)

    setMapData = (obj, isLoding) ->
      Api.getJson(obj, Const.API.SHOP + "/api.json", isLoding).then (resShops) ->
        $scope.isRefresh = false
        # 検索データの保存
        $rootScope.latitude = resShops.data.current.latitude
        $rootScope.longitude = resShops.data.current.longitude
        $rootScope.targetAddress = resShops.data.current.address
        # mapデータ設定
        if !$scope.isDragging
          $scope.map.center.latitude = resShops.data.current.latitude
          $scope.map.center.longitude = resShops.data.current.longitude
        $scope.isDragging = false;
        shops = []
        # map表示用データの作成
        angular.forEach resShops.data.shops, (shop, i) ->
          ret =
            latitude: shop.latitude,
            longitude: shop.longitude,
            showWindow: true,
            title: shop.name
            url: shop.image.thumb.url
          ret['id'] = shop.id
          shops.push(ret)
        $scope.targetMarkers = shops

    $scope.clickMarker = ($event) ->

    $scope.moveToCurrentPlace = ->
      $rootScope.targetAddress = null
      $scope.init()
