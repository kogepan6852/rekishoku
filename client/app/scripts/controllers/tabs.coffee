'use strict'

###*
 # @ngdoc function
 # @name frontApp.controller:TabsCtrl
 # @description
 # WritersCtrl
 # Controller of the frontApp
###
angular.module "frontApp"
  .controller "TabsCtrl", ($scope, $rootScope, $ionicTabsDelegate, $location, $ionicNavBarDelegate, $ionicHistory, $translate) ->

    ###
    # Common function
    ###
    checkPath = ->
      currentPath = $location.path();
      if currentPath.indexOf('/store/list') != -1
        $rootScope.currentType = 'store'
      else if currentPath.indexOf('/store/map') != -1
        $rootScope.currentType = 'map'
      else
        $rootScope.currentType = 'magazine'

    ###
    # Function
    ###
    $scope.clickTab = (index) ->
      # backボタンを隠す
      $ionicNavBarDelegate.showBackButton false
      # historyデータを削除する
      $ionicHistory.clearHistory();
      # $ionicHistory.clearCache();
      if index == 0
        $rootScope.appTitle = $translate.instant('SEO.TITLE.HOME')
        $location.path('/app/magazine').search('keywords', null)
        $rootScope.currentType = 'magazine'
      else if index == 1
        $rootScope.appTitle = $translate.instant('SEO.TITLE.SHOP')
        $location.path('/app/store/list').search('keywords', null)
        $rootScope.currentType = 'store'

    $scope.changeListType = ->
      checkPath()
      currentPath = $location.path();
      if $rootScope.currentType == 'store'
        $rootScope.isDown = false
        $location.path('/app/store/map')
      else
        $location.path('/app/store/list')
