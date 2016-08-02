'use strict'

###*
 # @ngdoc function
 # @name frontApp.controller:BaseCtrl
 # @description
 # # BaseCtrl
 # Controller of the frontApp
###
angular.module "frontApp"
  .controller "BaseCtrl", ($scope, $rootScope, Api, Const, $location, $ionicNavBarDelegate, $timeout, $window) ->

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
      $rootScope.hideFooter = true
      $rootScope.hideModeBtn = false

    $scope.onDragDownScroll = ->
      $rootScope.isDown = false
      $rootScope.hideFooter = false
      $rootScope.isHideTab = false
      $rootScope.hideModeBtn = false

    # 検索用キーワードをセットする処理
    $scope.getSearchData = ->
      keywords = null
      period = null
      person = null
      category = null
      province = null

      # キーワードの設定
      $scope.keywords = $location.search()['keywords']
      if $scope.keywords
        keywords = $scope.keywords
      # 時代の設定
      $scope.period = $location.search()['period']
      if $scope.period
        period = $scope.period
      # 人物の設定
      $scope.person = $location.search()['person']
      if $scope.person
        person = $scope.person
      # カテゴリーの設定
      $scope.category = $location.search()['category']
      if $scope.category
        category = $scope.category
      # 都道府県の設定
      $scope.province = $location.search()['province']
      if $scope.province
        province = $scope.province

      # 戻り値の設定
      rtn =
        keywords: keywords
        period: period
        person: person
        category: category
        province: province

      return rtn

    # 検索条件削除
    $scope.deleteSearchCondition = ->
      $scope.noMoreLoad = false

      $scope.category = null
      $scope.keywords = null
      $scope.period = null
      $scope.person = null
      $scope.province = null
      $location.search('category', null)
      $location.search('keywords', null)
      $location.search('period', null)
      $location.search('person', null)
      $location.search('province', null)
      $scope.search()

    # Prerender.ioにcache取得の通知をする
    $scope.readyToCache = (time) ->
      # Prerender.io
      $timeout (->
        $window.prerenderReady = true;
      ), time

    # レイアウトのリサイズを検知
    $scope.$on 'resize::resize', (event, args) ->
      $rootScope.windowType = args.windowType
