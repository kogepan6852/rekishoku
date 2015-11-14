'use strict'

###*
 # @ngdoc function
 # @name frontApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the frontApp
###
angular.module "frontApp"
  .controller "MainCtrl", ($scope, $rootScope, $ionicSideMenuDelegate, $controller, Api, Const) ->

    # Controllerの継承
    $controller 'BaseCtrl', $scope: $scope

    # setting
    $scope.targetCategoryId = null
    $scope.page = 1
    $scope.noMoreLoad = false

    # initialize
    categoryObj =
      type: "PostCategory"
    Api.getJson(categoryObj, Const.API.CATEGORY).then (res) ->
      $scope.categories = res.data

    $scope.init = ->
      obj =
        per: 20
        page: 1
      Api.getJson(obj, Const.API.POST).then (res) ->
        $scope.posts = res.data
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
      Api.getJson(obj, Const.API.POST).then (res) ->
        $scope.posts = res.data

    $scope.loadMoreData = ->
      $scope.page += 1
      obj =
        per: 20
        page: $scope.page
        category: $scope.targetCategoryId
      Api.getJson(obj, Const.API.POST).then (res) ->
        if res.data.length == 0
          $scope.noMoreLoad = true
        else
          angular.forEach res.data, (data, i) ->
            $scope.posts.push(data)
          $scope.$broadcast('scroll.infiniteScrollComplete')
