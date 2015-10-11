'use strict'

###*
 # @ngdoc function
 # @name frontApp.controller:PostDetailCtrl
 # @description
 # # PostDetailCtrl
 # Controller of the frontApp
###
angular.module 'frontApp'
  .controller "PostDetailCtrl", ($scope, $stateParams, $sessionStorage, Api, Const) ->

    # 変数設定
    $scope.targetId = $stateParams.id

    # 初期処理
    Api.getJson("", Const.API.POST + '/' + $stateParams.id).then (res) ->
      $scope.post = res.data
      Api.getJson("", Const.API.POST_DETSIL + '/' + res.data.id).then (res) ->
        $scope.postDetails = res.data

    # Function
