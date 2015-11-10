'use strict'

###*
 # @ngdoc function
 # @name frontApp.controller:WritersCtrl
 # @description
 # WritersCtrl
 # Controller of the frontApp
###
angular.module "frontApp"
  .controller "WritersCtrl", ($scope, $ionicSideMenuDelegate, Api, Const) ->

    # setting

    # initialize
    $scope.init = ->
      Api.getJson("", Const.API.USER + '.json').then (res) ->
        $scope.users = res.data
        $scope.$broadcast 'scroll.refreshComplete'

    # Function
