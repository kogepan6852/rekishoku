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
    $rootScope.appTitle = "歴食.jp | 食べる、歴史体験"
    $rootScope.appDescription = "夏目漱石が愛した和菓子、伊達政宗が考えたお餅、江戸っ子に人気の鍋。”ストーリーのある食”を”食べに行ける店”と合わせてご紹介します。新しい食体験と歴史体験、是非合わせて味わってみてください。"
    $rootScope.appImage = "https://rekishoku.jp/logo.png"
    $rootScope.appKeywords = "歴食,暦食,郷土料理,rekishoku,rekisyoku"

    path = $location.path()
    if path.indexOf('/app/writers') != -1 || path.indexOf('/app/my-post') != -1
      $ionicNavBarDelegate.showBackButton false
    else
      $ionicNavBarDelegate.showBackButton true

    $scope.onDragUpScroll = ->
      $rootScope.isDown = true
      $rootScope.hideFooter = true
      $rootScope.hideModeBtn = true

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
      param = $location.search()['keywords']
      if param
        keywords = param
      # 時代の設定
      param = $location.search()['period']
      if param
        period = Number(param)
      # 人物の設定
      param = $location.search()['person']
      if param
        person = Number(param)
      # カテゴリーの設定
      param = $location.search()['category']
      if param
        category = Number(param)
      # 都道府県の設定
      param = $location.search()['province']
      if param
        province = param

      # scopeに設定
      $scope.keywords = keywords
      $scope.period = period
      $scope.person = person
      $scope.category = category
      $scope.province = province

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
      $location.search('reload', null)
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

    $scope.reload = ->
      $rootScope.isReload = true
