'use strict'

###*
 # @ngdoc function
 # @name frontApp.controller:ShopsCtrl
 # @description
 # # MainCtrl
 # Controller of the frontApp
###
angular.module "frontApp"
  .controller "ShopsCtrl", ($scope, $rootScope, $ionicSideMenuDelegate, $location, $controller, $ionicNavBarDelegate, $translate, Api, Const, DataService) ->

    # Controllerの継承
    $controller 'BaseCtrl', $scope: $scope

    ###
    # setting
    ###
    $scope.targetCategoryId = null
    $rootScope.isHideTab = false
    $ionicNavBarDelegate.showBackButton false

    DataService.getShopCategory (data) ->
      $scope.categories = data
    DataService.getPeriod (data) ->
      $scope.periods = data
    DataService.getPeople (data) ->
      $scope.people = data

    ###
    # initialize
    ###
    $scope.init = ->
      $scope.noMoreLoad = false
      $scope.page = 1
      obj =
        per: 20
        page: 1
      if $scope.targetCategoryId
        obj.category = $scope.targetCategoryId
      # 検索ワードの設定
      $scope.keywords = $location.search()['keywords']
      if $scope.keywords
        obj.keywords = $scope.keywords

      Api.getJson(obj, Const.API.SHOP, true).then (res) ->
        $scope.results = res.data
        $scope.$broadcast 'scroll.refreshComplete'
        $scope.$broadcast('scroll.infiniteScrollComplete')

    ###
    # Global function
    ###
    $rootScope.shopsSearch = (categoryId) ->
      $scope.targetCategoryId = null
      $scope.search(categoryId)

    ###
    # function
    ###
    # 検索処理
    $scope.search = (categoryId) ->
      $scope.page = 1
      obj =
        per: Const.API.SETTING.PER
        page: $scope.page
      if categoryId == $scope.targetCategoryId
        # 検索条件解除
        $scope.targetCategoryId = null
      else
        # 検索条件設定
        $scope.targetCategoryId = categoryId
        obj.category = categoryId

      # 検索ワードの設定
      searchSata = $scope.getSearchData()
      obj.keywords = searchSata.keywords
      obj.period = searchSata.period
      obj.person = searchSata.person

      # 検索
      Api.getJson(obj, Const.API.SHOP + '.json', true).then (res) ->
        $scope.results = res.data
        if res.data.length == 0
          $scope.noMoreLoad = true
        $scope.$broadcast('scroll.infiniteScrollComplete')

    # 店舗詳細移動時の処理
    $scope.moveToStoreDetail = ->
      $rootScope.isDown = true

    # ListのLazy Load用処理
    $scope.loadMoreData = ->
      if $scope.results
        $scope.page += 1
        obj =
          per: Const.API.SETTING.PER
          page: $scope.page
          category: $scope.targetCategoryId
        # 検索ワードの設定
        if $scope.keywords
          obj.keywords = $scope.keywords

        Api.getJson(obj, Const.API.SHOP, true).then (res) ->
          if res.data.length == 0
            $scope.noMoreLoad = true
          else
            angular.forEach res.data, (data, i) ->
              $scope.results.push(data)
          $scope.$broadcast('scroll.infiniteScrollComplete')
