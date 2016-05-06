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
      if currentPath.indexOf('/shop/list') != -1
        $rootScope.currentType = 'shop'
      else if currentPath.indexOf('/shop/map') != -1
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
      $rootScope.hideFooter = false
      $rootScope.hideModeBtn = false

      if index == 0
        $rootScope.appTitle = $translate.instant('SEO.TITLE.HOME')
        $location.path('/app/magazine').search('keywords', null)
        $rootScope.currentType = 'magazine'

      else if index == 1
        $rootScope.appTitle = $translate.instant('SEO.TITLE.SHOP')
        $location.path('/app/shop/list').search('keywords', null)
        $rootScope.currentType = 'shop'

    $scope.changeListType = ->
      checkPath()
      currentPath = $location.path();
      if $rootScope.currentType == 'shop'
        $rootScope.hideFooter = false
        $rootScope.currentType = 'map'
        $location.path('/app/shop/map')
      else
        $rootScope.currentType = 'shop'
        $location.path('/app/shop/list')
