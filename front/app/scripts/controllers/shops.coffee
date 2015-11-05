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
    categoryObj =
      type: "ShopCategory"
    Api.getJson(categoryObj, Const.API.CATEGORY).then (res) ->
      $scope.categories = res.data

    $scope.init = ->
      Api.getJson("", Const.API.SHOP + '.json').then (res) ->
        $scope.results = res.data
        $scope.$broadcast 'scroll.refreshComplete'

    # Function
