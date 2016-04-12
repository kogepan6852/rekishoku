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
