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
    $rootScope.appDescription = "歴食は武将や文豪、その時代の人たちが愛した食を見るだけでなく食べる体験を提供するサイトです."
    $rootScope.appImage = "http://rekishoku.jp/logo.png"
    $rootScope.appKeywords = "歴史,偉人,食事,歴食,郷土料理,暦食"


    path = $location.path()
    if path.indexOf('/app/home') != -1 || path.indexOf('/app/writers') != -1 || path.indexOf('/app/my-post') != -1
      $ionicNavBarDelegate.showBackButton false
    else
      $ionicNavBarDelegate.showBackButton true

    $scope.onDragUpScroll = ->
      $rootScope.isDown = true

    $scope.onDragDownScroll = ->
      $rootScope.isDown = false
      $rootScope.isHideTab = false
