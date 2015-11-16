'use strict'

###*
 # @ngdoc function
 # @name frontApp.controller:PostDetailCtrl
 # @description
 # # PostDetailCtrl
 # Controller of the frontApp
###
angular.module 'frontApp'
  .controller "PostDetailCtrl", ($scope, $stateParams, $ionicHistory, $sessionStorage, $controller, Api, Const) ->

    # Controllerの継承
    $controller 'BaseCtrl', $scope: $scope

    # 変数設定
    $scope.targetId = $stateParams.id

    # 初期処理
    path = Const.API.POST + '/' + $stateParams.id
    Api.getJson("", path).then (res) ->
      $scope.post = res.data.post
      $scope.shops = res.data.shops
      Api.getJson("", Const.API.POST_DETSIL + '/' + res.data.post.id).then (res) ->
        $scope.postDetails = res.data

    # Function
    $scope.myGoBack = ->
      $ionicHistory.goBack()
