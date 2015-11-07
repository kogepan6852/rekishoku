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
    $scope.targetCategoryId = null

    # initialize
    categoryObj =
      type: "ShopCategory"
    Api.getJson(categoryObj, Const.API.CATEGORY).then (res) ->
      $scope.categories = res.data

    $scope.init = ->
      Api.getJson("", Const.API.SHOP + '.json').then (res) ->
        $scope.results = res.data
        $scope.$broadcast 'scroll.refreshComplete'
        $scope.targetCategoryId = null

    # Function
    $scope.search = (categoryId) ->
      if categoryId == $scope.targetCategoryId
        # 検索条件解除
        $scope.targetCategoryId = null
        obj = ""
      else
        # 検索条件設定
        $scope.targetCategoryId = categoryId
        obj =
          category: categoryId
      # 検索
      Api.getJson(obj, Const.API.SHOP + '.json').then (res) ->
        $scope.results = res.data
