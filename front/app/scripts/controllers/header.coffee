'use strict'

###*
 # @ngdoc function
 # @name frontApp.controller:HeaderCtrl
 # @description
 # # HeaderCtrl
 # Controller of the frontApp
###
angular.module "frontApp"
  .controller "HeaderCtrl", ["$scope","$ionicSideMenuDelegate", ($scope, $ionicSideMenuDelegate) ->

    $scope.toggleRight = ->
      $ionicSideMenuDelegate.toggleRight();

]