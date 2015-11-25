'use strict'

###*
 # @ngdoc function
 # @name frontApp.controller:PostDetailCtrl
 # @description
 # # PostDetailCtrl
 # Controller of the frontApp
###
angular.module 'frontApp'
  .controller "PostDetailCtrl", ($scope, $rootScope, $stateParams, $ionicHistory, $sessionStorage, $controller, $state, Api, Const) ->

    # Controllerの継承
    $controller 'BaseCtrl', $scope: $scope

    # 変数設定
    $scope.targetId = $stateParams.id
    $rootScope.isHideTab = true

    # 初期処理
    path = Const.API.POST + '/' + $stateParams.id
    Api.getJson("", path, true).then (res) ->
      $scope.post = res.data.post
      $scope.shops = res.data.shops

      # SEO
      appKeywords = []
      angular.forEach $scope.shops, (shop) ->
        appKeywords.push(shop.shop.name)
      $rootScope.appTitle = $scope.post.title
      $rootScope.appDescription = $scope.post.content.substr(0, 150)
      $rootScope.appImage = $scope.post.image.url
      $rootScope.appKeywords = appKeywords.join()

      Api.getJson("", Const.API.POST_DETSIL + '/' + res.data.post.id, true).then (res) ->
        $scope.postDetails = res.data

    # 現在タブの判定
    if $state.is('tabs.post')
      $scope.nowTab = 'post'
    else if $state.is('tabs.map') || $state.is('tabs.map-post')
      $scope.nowTab = 'map'
    else if $state.is('tabs.shop') || $state.is('tabs.shop-post')
      $scope.nowTab = 'shop'

    # Function
    $scope.myGoBack = ->
      $ionicHistory.goBack()
