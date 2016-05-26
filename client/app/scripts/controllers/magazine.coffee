'use strict'

###*
 # @ngdoc function
 # @name frontApp.controller:MagazineCtrl
 # @description
 # # MainCtrl
 # Controller of the frontApp
###
angular.module "frontApp"
  .controller "MagazineCtrl", ($scope, $rootScope, $controller, $ionicNavBarDelegate, $localStorage, Api, Const, DataService, $state) ->

    # Controllerの継承
    $controller 'BaseCtrl', $scope: $scope

    ###
    # setting
    ###
    $rootScope.isHideTab = false
    $ionicNavBarDelegate.showBackButton false

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
      $scope.noMoreLoad = false
      $scope.page = 1
      obj =
        email: $localStorage['email']
        token: $localStorage['token']
        per: Const.API.SETTING.PER
        page: 1
      # 検索ワードの設定
      searchSata = $scope.getSearchData()
      obj.keywords = searchSata.keywords
      obj.period = searchSata.period
      obj.person = searchSata.person
      obj.category = searchSata.category
      obj.province = searchSata.province

      # 特集テスト用データ
      $scope.feature = {
        post: {
          title: "幕末時代の甘味処10選",
          content: "ここにテキスト。ここにテキスト。ここにテキスト。ここにテキスト。ここにテキスト。ここにテキスト。",
          image: "../images/sample.png"
        },
        people: [{name: "JK"}, {name: "こげぱん"}, {name: "堅固潤也"}]
        periods: [{name: "江戸時代"}]
      }

      # 記事一覧取得
      Api.getJson(obj, Const.API.POST, true).then (res) ->
        $scope.results = res.data
        $scope.$broadcast 'scroll.refreshComplete'
        $scope.$broadcast('scroll.infiniteScrollComplete')

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
      searchSata = $scope.getSearchData()
      obj.keywords = searchSata.keywords
      obj.period = searchSata.period
      obj.person = searchSata.person
      obj.category = searchSata.category
      obj.province = searchSata.province

      # 検索
      Api.getJson(obj, Const.API.POST, true).then (res) ->
        $scope.results = res.data
        if res.data.length == 0
          $scope.noMoreLoad = true
        $scope.$broadcast('scroll.infiniteScrollComplete')

    # 記事詳細移動時の処理
    $scope.moveToPostDetail = (id) ->
      $ionicNavBarDelegate.showBackButton true
      $state.go 'tabs.postDetal', {id:id}

    # ListのLazy Load用処理
    $scope.loadMoreData = ->
      if $scope.results
        $scope.page += 1
        obj =
          per: Const.API.SETTING.PER
          page: $scope.page
        # 検索ワードの設定
        searchSata = $scope.getSearchData()
        obj.keywords = searchSata.keywords
        obj.period = searchSata.period
        obj.person = searchSata.person
        obj.category = searchSata.category
        obj.province = searchSata.province

        Api.getJson(obj, Const.API.POST, true).then (res) ->
          if res.data.length == 0
            $scope.noMoreLoad = true
          else
            angular.forEach res.data, (data, i) ->
              $scope.results.push(data)
          $scope.$broadcast('scroll.infiniteScrollComplete')
