'use strict'

###*
 # @ngdoc function
 # @name frontApp.controller:BaseCtrl
 # @description
 # # BaseCtrl
 # Controller of the frontApp
###
angular.module "frontApp"
  .controller "BaseCtrl", ($scope, $rootScope, Api, Const) ->

    $scope.onDragUp = ->
      $rootScope.isDown = true

    $scope.onDragDown = ->
      $rootScope.isDown = false
