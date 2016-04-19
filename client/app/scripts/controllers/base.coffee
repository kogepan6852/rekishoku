'use strict'

###*
 # @ngdoc function
 # @name frontApp.controller:BaseCtrl
 # @description
 # # BaseCtrl
 # Controller of the frontApp
###
angular.module "frontApp"
  .controller "BaseCtrl", ($scope, $rootScope, Api, Const, $location, $ionicNavBarDelegate) ->

    # initialize
    $rootScope.isHideTab = false
    $rootScope.appTitle = "歴食"
    $rootScope.appDescription = "歴食は武将や文豪、その時代の人たちが愛した食を見るだけでなく、食べる体験を提供するサイトです."
    $rootScope.appImage = "http://rekishoku.jp/logo.png"
    $rootScope.appKeywords = "歴食,暦食,郷土料理,rekishoku,rekisyoku"


    path = $location.path()
    if path.indexOf('/app/writers') != -1 || path.indexOf('/app/my-post') != -1
      $ionicNavBarDelegate.showBackButton false
    else
      $ionicNavBarDelegate.showBackButton true

    $scope.onDragUpScroll = ->
      $rootScope.isDown = true

    $scope.onDragDownScroll = ->
      $rootScope.isDown = false
      $rootScope.isHideTab = false

    # 検索用キーワードをセットする処理
    $scope.getSearchData = ->
      # キーワードの設定
      $scope.keywords = $location.search()['keywords']
      keywords = null
      if $scope.keywords
        keywords = $scope.keywords
      period = null
      # 時代の設定
      $scope.period = $location.search()['period']
      if $scope.period
        period = $scope.period

      # 戻り値の設定
      rtn =
        keywords: keywords
        period: period

      return rtn

    # 検索条件削除
    $scope.deleteSearchCondition = ->
      $scope.targetCategoryId = null
      $scope.keywords = null
      $scope.period = null
      $location.search('keywords', null)
      $location.search('period', null)
      $scope.search()
