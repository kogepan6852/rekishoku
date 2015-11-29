'use strict'

###*
 # @ngdoc function
 # @name frontApp.controller:ShopsCtrl
 # @description
 # # MainCtrl
 # Controller of the frontApp
###
angular.module "frontApp"
  .controller "ShopsCtrl", ($scope, $rootScope, $ionicSideMenuDelegate, $controller, Api, Const) ->

    # Controllerの継承
    $controller 'BaseCtrl', $scope: $scope

    # setting
    $scope.targetCategoryId = null
    $scope.page = 1
    $scope.noMoreLoad = false
    $rootScope.isHideTab = false

    # initialize
    categoryObj =
      type: "ShopCategory"
    Api.getJson(categoryObj, Const.API.CATEGORY, true).then (res) ->
      $scope.categories = res.data

    $scope.init = ->
      obj =
        per: 20
        page: 1
      Api.getJson(obj, Const.API.SHOP + '/api.json', true).then (res) ->
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
      Api.getJson(obj, Const.API.SHOP + '/api.json', true).then (res) ->
        $scope.results = res.data

    $scope.loadMoreData = ->
      if $scope.results
        $scope.page += 1
        obj =
          per: 20
          page: $scope.page
          category: $scope.targetCategoryId
        Api.getJson(obj, Const.API.SHOP + '/api.json', true).then (res) ->
          if res.data.length == 0
            $scope.noMoreLoad = true
          else
            angular.forEach res.data, (data, i) ->
              $scope.results.push(data)
          $scope.$broadcast('scroll.infiniteScrollComplete')
