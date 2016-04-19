'use strict'

###*
 # @ngdoc function
 # @name frontApp.controller:WritersCtrl
 # @description
 # WritersCtrl
 # Controller of the frontApp
###
angular.module "frontApp"
  .controller "WritersCtrl", ($scope, $rootScope, $ionicSideMenuDelegate, $controller, Api, Const, $translate) ->

    # Controllerの継承
    $controller 'BaseCtrl', $scope: $scope

    # setting
    $rootScope.appTitle = $translate.instant('SEO.TITLE.WRITERS')

    # initialize
    $scope.init = ->
      Api.getJson("", Const.API.USER, true).then (res) ->
        $scope.users = res.data
        $scope.$broadcast 'scroll.refreshComplete'

    # Function
