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
        $scope.keywords = param
        keywords = $scope.keywords
      # 時代の設定
      param = $location.search()['period']
      if param
        $scope.period = Number(param)
        period = $scope.period
      # 人物の設定
      param = $location.search()['person']
      if param
        $scope.person = Number(param)
        person = $scope.person
      # カテゴリーの設定
      param = $location.search()['category']
      if param
        $scope.category = Number(param)
        category = $scope.category
      # 都道府県の設定
      param = $location.search()['province']
      if param
        $scope.province = param
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
