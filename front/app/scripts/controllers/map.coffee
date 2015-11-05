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
    $scope.input = {
      address: null
    }

    defaultZoom = 14
    targetDistance = BaseService.calMapDistance(defaultZoom)

    $scope.map =
      center:
        latitude: 35.6813818
        longitude: 139.7660838
      zoom: defaultZoom
      bounds: {}
    $scope.options =
      scrollwheel: false
      minZoom: 11

    $scope.events =
      dragstart: (cluster, clusterModels) ->
        $ionicSideMenuDelegate.canDragContent(false)
      dragend: (cluster, clusterModels) ->
        $ionicSideMenuDelegate.canDragContent(true)
        obj =
          latitude: cluster.center.G
          longitude: cluster.center.K
          shopDistance: targetDistance
        # map表示用データの作成と設定
        setMapData(obj)
      zoom_changed: (cluster, clusterModels) ->
        # GoogleMapの距離計算
        targetDistance = BaseService.calMapDistance(cluster.zoom)
        obj =
          placeAddress: $scope.input.address
          shopDistance: targetDistance
        # map表示用データの作成と設定
        setMapData(obj)

    $scope.targetMarkers = []

    # 初期処理
    $scope.init = ->
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
          setMapData(obj)

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
      setMapData(obj)

    setMapData = (obj) ->
      Api.getJson(obj, Const.API.SHOP + ".json").then (resShops) ->
        $scope.map.center.latitude = resShops.data.current.latitude
        $scope.map.center.longitude = resShops.data.current.longitude
        $scope.input.address = resShops.data.current.address
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
