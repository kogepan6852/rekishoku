'use strict'

###*
 # @ngdoc function
 # @name frontApp.controller:FeaturesCtrl
 # @description
 # # FeaturesCtrl
 # Controller of the frontApp
###
angular.module "frontApp"
  .controller "FeaturesCtrl", ($scope, $rootScope, $controller, $ionicNavBarDelegate, $localStorage, Api, Const, DataService, $state, $location) ->

    # Controllerの継承
    $controller 'BaseCtrl', $scope: $scope

    ###
    # setting
    ###
    $scope.$on '$ionicView.enter', (e) ->
      $rootScope.currentType = 'feature'
      $rootScope.isHideTab = false
      $ionicNavBarDelegate.showBackButton false
      if $rootScope.isReload == true && $scope.results
        $rootScope.isReload = false
        $rootScope.featuresSearch()

    DataService.getFeatureCategory (data) ->
      $scope.categories = data
    DataService.getPeriod (data) ->
      $scope.periods = data
    DataService.getPeople (data) ->
      $scope.people = data

    ###
    # initialize
    ###
    $scope.init = ->
      $rootScope.isReload = false
      $scope.noMoreLoad = false
      $scope.page = 1
      obj =
        email: $localStorage['email']
        token: $localStorage['token']
        per: Const.API.SETTING.PER
        page: 1
      # 検索ワードの設定
      searchData = $scope.getSearchData()
      obj.keywords = searchData.keywords
      obj.period = searchData.period
      obj.person = searchData.person
      obj.category = searchData.category
      obj.province = searchData.province

      # 記事一覧取得
      Api.getJson(obj, Const.API.FEATURE, false).then (res) ->
        $scope.topItem = res.data[0]
        $scope.results = res.data
        $scope.$broadcast 'scroll.refreshComplete'
        $scope.$broadcast('scroll.infiniteScrollComplete')

    ###
    # Global function
    ###
    $rootScope.featuresSearch = ->
      $scope.noMoreLoad = false
      $scope.search()

    ###
    # function
    ###
    # 検索処理
    $scope.search = ->
      $scope.page = 1
      obj =
        per: Const.API.SETTING.PER
        page: $scope.page

      # 検索ワードの設定
      searchData = $scope.getSearchData()
      obj.keywords = searchData.keywords
      obj.period = searchData.period
      obj.person = searchData.person
      obj.category = searchData.category
      obj.province = searchData.province

      # 検索
      Api.getJson(obj, Const.API.FEATURE, false).then (res) ->
        $scope.results = res.data
        if res.data.length == 0
          $scope.noMoreLoad = true
        $scope.$broadcast('scroll.infiniteScrollComplete')

    # ListのLazy Load用処理
    $scope.loadMoreData = ->
      if $scope.results
        $scope.page += 1
        obj =
          per: Const.API.SETTING.PER
          page: $scope.page
        # 検索ワードの設定
        obj.keywords = $scope.keywords
        obj.period = $scope.period
        obj.person = $scope.person
        obj.category = $scope.category
        obj.province = $scope.province

        Api.getJson(obj, Const.API.FEATURE, false).then (res) ->
          if res.data.length == 0
            $scope.noMoreLoad = true
            # Prerender.io
            $scope.readyToCache(1000)

          else
            angular.forEach res.data, (data, i) ->
              $scope.results.push(data)
          $scope.$broadcast('scroll.infiniteScrollComplete')
