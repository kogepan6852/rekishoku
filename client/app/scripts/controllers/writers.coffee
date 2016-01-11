'use strict'

###*
 # @ngdoc function
 # @name frontApp.controller:WritersCtrl
 # @description
 # WritersCtrl
 # Controller of the frontApp
###
angular.module "frontApp"
  .controller "WritersCtrl", ($scope, $ionicSideMenuDelegate, $controller, Api, Const) ->

    # Controllerの継承
    $controller 'BaseCtrl', $scope: $scope

    # setting

    # initialize
    $scope.init = ->
      Api.getJson("", Const.API.USER, true).then (res) ->
        $scope.users = res.data
        $scope.$broadcast 'scroll.refreshComplete'

    # Function
