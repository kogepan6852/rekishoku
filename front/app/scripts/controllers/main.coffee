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
    $scope.targetCategoryId = null

    # initialize
    categoryObj =
      type: "PostCategory"
    Api.getJson(categoryObj, Const.API.CATEGORY).then (res) ->
      $scope.categories = res.data

    $scope.init = ->
      Api.getJson("", Const.API.POST).then (res) ->
        $scope.posts = res.data
        $scope.$broadcast 'scroll.refreshComplete'
        $scope.targetCategoryId = null

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
      Api.getJson(obj, Const.API.POST).then (res) ->
        $scope.posts = res.data

    # Function
