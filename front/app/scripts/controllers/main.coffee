'use strict'

###*
 # @ngdoc function
 # @name frontApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the frontApp
###
angular.module "frontApp"
  .controller "MainCtrl", ($scope, $ionicSideMenuDelegate, Api) ->

    # setting

    # initialize
    Api.getPostListAll().then (res) ->
      $scope.results = res.data

    # Function
