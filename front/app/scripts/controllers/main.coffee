'use strict'

###*
 # @ngdoc function
 # @name frontApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the frontApp
###
angular.module "frontApp"
  .controller "MainCtrl", ($scope, $ionicSideMenuDelegate, Api, Const) ->

    # setting

    # initialize
    categoryObj =
      type: "PostCategory"
    Api.getJson(categoryObj, Const.API.CATEGORY).then (res) ->
      $scope.categories = res.data

    $scope.init = ->
      Api.getJson("", Const.API.POST).then (res) ->
        $scope.posts = res.data
        $scope.$broadcast 'scroll.refreshComplete'

    # Function
