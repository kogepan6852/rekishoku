'use strict'

###*
 # @ngdoc function
 # @name frontApp.controller:ShopDetailCtrl
 # @description
 # # PostDetailCtrl
 # Controller of the frontApp
###
angular.module 'frontApp'
  .controller "ShopDetailCtrl", ($scope, $rootScope, $stateParams, $sessionStorage, $controller, $state, Api, Const) ->

    # Controllerの継承
    $controller 'BaseCtrl', $scope: $scope

    # 変数設定
    $scope.targetId = $stateParams.id
    $rootScope.isHideTab = true

    # 初期処理
    Api.getJson("", Const.API.SHOP + '/' + $stateParams.id + '.json', true).then (res) ->
      $scope.shop = res.data.shop
      $scope.categories = res.data.categories
      $scope.posts = res.data.posts
      $scope.people = res.data.people

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
        draggable: false

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

      # SEO
      appKeywords = []
      angular.forEach $scope.people, (person) ->
        appKeywords.push(person.name)
      $rootScope.appTitle = $scope.shop.name
      $rootScope.appDescription = $scope.shop.description.substr(0, 150)
      $rootScope.appImage = $scope.shop.subimage.url
      $rootScope.appKeywords = appKeywords.join()


    # 現在タブの判定
    if $state.is('tabs.post') || $state.is('tabs.post-shop')
      $scope.nowTab = 'post'
    else if $state.is('tabs.map') || $state.is('tabs.map-shop') || $state.is('tabs.map-shop2')
      $scope.nowTab = 'map'
    else if $state.is('tabs.shop')
      $scope.nowTab = 'shop'


    # Function
