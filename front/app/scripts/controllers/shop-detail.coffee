'use strict'

###*
 # @ngdoc function
 # @name frontApp.controller:ShopDetailCtrl
 # @description
 # # PostDetailCtrl
 # Controller of the frontApp
###
angular.module 'frontApp'
  .controller "ShopDetailCtrl", ($scope, $stateParams, $sessionStorage, Api, Const) ->

    # 変数設定
    $scope.targetId = $stateParams.id

    # 初期処理
    Api.getJson("", Const.API.SHOP + '/' + $stateParams.id + '.json').then (res) ->
      $scope.shop = res.data

    # Function
