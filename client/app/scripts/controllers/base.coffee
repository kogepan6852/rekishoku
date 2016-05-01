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
    $rootScope.appTitle = "歴食 | 食べる、歴史体験"
    $rootScope.appDescription = "夏目漱石が愛した和菓子、伊達政宗が考えたお餅、江戸っ子に人気の鍋。”ストーリーのある食”を”食べに行ける店”と合わせてご紹介します。新しい食体験と歴史体験、是非合わせて味わってみてください。"
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
      # 人物の設定
      $scope.person = $location.search()['person']
      if $scope.person
        person = $scope.person

      # 戻り値の設定
      rtn =
        keywords: keywords
        period: period
        person: person

      return rtn

    # 検索条件削除
    $scope.deleteSearchCondition = ->
      $scope.targetCategoryId = null
      $scope.keywords = null
      $scope.period = null
      $scope.person = null
      $location.search('keywords', null)
      $location.search('period', null)
      $location.search('person', null)
      $scope.search()
