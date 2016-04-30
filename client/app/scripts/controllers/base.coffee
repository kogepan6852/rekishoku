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
