'use strict'

###*
 # @ngdoc function
 # @name frontApp.controller:WritersCtrl
 # @description
 # WritersCtrl
 # Controller of the frontApp
###
angular.module "frontApp"
  .controller "WritersCtrl", ($scope, $rootScope, $ionicSideMenuDelegate, $controller, Api, Const, $translate, $ionicNavBarDelegate) ->

    # Controllerの継承
    $controller 'BaseCtrl', $scope: $scope

    # setting
    $scope.$on '$ionicView.enter', (e) ->
      $ionicNavBarDelegate.showBackButton false

    # initialize
    $scope.init = ->
      Api.getJson("", Const.API.USER, false).then (res) ->
        $scope.users = res.data
        $scope.$broadcast 'scroll.refreshComplete'

    # Function
