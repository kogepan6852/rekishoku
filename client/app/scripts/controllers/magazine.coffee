'use strict'

###*
 # @ngdoc function
 # @name frontApp.controller:MagazineCtrl
 # @description
 # # MainCtrl
 # Controller of the frontApp
###
angular.module "frontApp"
  .controller "MagazineCtrl", ($scope, $rootScope, $controller, $ionicNavBarDelegate, $localStorage, Api, Const, DataService, $state, $location) ->

    # Controllerの継承
    $controller 'BaseCtrl', $scope: $scope

    ###
    # setting
    ###
    $scope.$on '$ionicView.enter', (e) ->
      $rootScope.currentType = 'magazine'
      $rootScope.isHideTab = false
      $ionicNavBarDelegate.showBackButton false
      if $rootScope.isReload == true && $scope.results
        $rootScope.isReload = false
        $rootScope.postsSearch()

    DataService.getPostCategory (data) ->
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
      Api.getJson(obj, Const.API.POST, false).then (res) ->
        $scope.topItem = res.data[0]
        $scope.results = res.data
        $scope.$broadcast 'scroll.refreshComplete'
        $scope.$broadcast('scroll.infiniteScrollComplete')

      # TOP用情報取得
      objTop =
        email: $localStorage['email']
        token: $localStorage['token']
        per: 1
        page: 1
      # 最新ショップ取得
      Api.getJson(objTop, Const.API.SHOP, false).then (res) ->
        if res.data.length > 0
          $scope.shop = res.data[0]

      # 最新特集取得
      Api.getJson(objTop, Const.API.FEATURE, false).then (res) ->
        if res.data.length > 0
          $scope.feature = res.data[0]


    ###
    # Global function
    ###
    $rootScope.postsSearch = ->
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
      Api.getJson(obj, Const.API.POST, false).then (res) ->
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

        Api.getJson(obj, Const.API.POST, false).then (res) ->
          if res.data.length == 0
            $scope.noMoreLoad = true
            # Prerender.io
            $scope.readyToCache(1000)

          else
            angular.forEach res.data, (data, i) ->
              $scope.results.push(data)
          $scope.$broadcast('scroll.infiniteScrollComplete')
