'use strict'

###*
 # @ngdoc function
 # @name frontApp.controller:ShopDetailCtrl
 # @description
 # # PostDetailCtrl
 # Controller of the frontApp
###
angular.module 'frontApp'
  .controller "ShopDetailCtrl", ($scope, $stateParams, $sessionStorage, $controller, Api, Const) ->

    # Controllerの継承
    $controller 'BaseCtrl', $scope: $scope

    # 変数設定
    $scope.targetId = $stateParams.id

    # 初期処理
    Api.getJson("", Const.API.SHOP + '/' + $stateParams.id + '.json').then (res) ->
      $scope.shop = res.data.shop
      $scope.categories = res.data.categories
      $scope.posts = res.data.posts

      # Map用
      $scope.map =
        center:
          latitude: res.data.shop.latitude
          longitude: res.data.shop.longitude
        zoom: 14
        bounds: {}
      $scope.options =
        scrollwheel: false
        minZoom: 11

      shops = []
      ret =
        latitude: res.data.shop.latitude
        longitude: res.data.shop.longitude
        showWindow: true
        title: res.data.shop.name
        url: res.data.shop.image.thumb.url
      ret['id'] = res.data.shop.id
      shops.push(ret)
      $scope.targetMarkers = shops

    # Function
