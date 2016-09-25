'use strict'

###*
 # @ngdoc function
 # @name frontApp.controller:TabsCtrl
 # @description
 # WritersCtrl
 # Controller of the frontApp
###
angular.module "frontApp"
  .controller "TabsCtrl", ($scope, $rootScope, $ionicTabsDelegate, $location, $ionicNavBarDelegate, $ionicHistory, $translate, $state, $ionicViewSwitcher) ->

    ###
    # Common function
    ###
    checkPath = ->
      currentPath = $location.path();
      if currentPath.indexOf('/shops') != -1
        $rootScope.currentType = 'shop'
      else if currentPath.indexOf('/map') != -1
        $rootScope.currentType = 'map'
      else if currentPath.indexOf('/features') != -1
        $rootScope.currentType = 'feature'
      else
        $rootScope.currentType = 'magazine'

    ###
    # Function
    ###
    $scope.clickTab = (index) ->
      # トランジション時のアニメーションをoffにする
      $ionicViewSwitcher.nextTransition('none')
      # backボタンを隠す
      $ionicNavBarDelegate.showBackButton false
      # historyデータを削除する
      $ionicHistory.clearHistory();
      $rootScope.hideFooter = false
      # reloadパラメータを削除
      $location.search('reload', null)

      if index == 0
        $rootScope.appTitle = $translate.instant('SEO.TITLE.BASE') + $translate.instant('SEO.TITLE.HOME')
        $location.path('/app/magazine').search('keywords', null)
        $rootScope.currentType = 'magazine'

      else if index == 1
        $rootScope.appTitle = $translate.instant('SEO.TITLE.BASE') + $translate.instant('SEO.TITLE.FEATURE')
        $location.path('/app/features').search('keywords', null)
        $rootScope.currentType = 'feature'

      else if index == 2
        $rootScope.appTitle = $translate.instant('SEO.TITLE.BASE') + $translate.instant('SEO.TITLE.SHOP')
        $location.path('/app/shops').search('keywords', null)
        $rootScope.currentType = 'shop'

      else if index == 3
        $rootScope.appTitle = $translate.instant('SEO.TITLE.BASE') + $translate.instant('SEO.TITLE.MAP')
        $location.path('/app/map').search('keywords', null)
        $rootScope.currentType = 'map'
