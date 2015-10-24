'use strict'

###*
 # @ngdoc function
 # @name frontApp.controller:AboutCtrl
 # @description
 # # AboutCtrl
 # Controller of the frontApp
###
angular.module 'frontApp'
  .controller 'MapCtrl', ($scope, $rootScope, $sessionStorage, Api, toaster, Const) ->

    # 変数設定
    $scope.input = {
      address: null
    }

    # Function
    $scope.searchShops = ->
      obj =
        placeAddress: $scope.input.address
        shopDistance: 10000
      Api.getJson(obj, Const.API.SHOP + ".json").then (resShops) ->
        $scope.map.center.latitude = resShops.data.current.latitude
        $scope.map.center.longitude = resShops.data.current.longitude
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

    $scope.map =
      center:
        latitude: 35.6813818
        longitude: 139.7660838
      zoom: 14
      bounds: {}
    $scope.options = scrollwheel: false

    $scope.targetMarkers = []

    $scope.clickMarker = ($event) ->
      
