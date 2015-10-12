'use strict'

###*
 # @ngdoc function
 # @name frontApp.controller:ShopsCtrl
 # @description
 # # MainCtrl
 # Controller of the frontApp
###
angular.module "frontApp"
  .controller "ShopsCtrl", ($scope, $ionicSideMenuDelegate, Api, Const) ->

    # setting

    # initialize
    Api.getJson("", Const.API.SHOP + '.json').then (res) ->
      $scope.results = res.data

    # Function
