'use strict'

###*
 # @ngdoc function
 # @name frontApp.controller:PostDetailCtrl
 # @description
 # # PostDetailCtrl
 # Controller of the frontApp
###
angular.module 'frontApp'
  .controller "PostDetailCtrl", ($scope, $stateParams, $sessionStorage, Api) ->

    # 変数設定
    $scope.targetId = $stateParams.id

    # 初期処理

    # Function
