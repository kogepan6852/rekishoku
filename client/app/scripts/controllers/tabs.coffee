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

    # Function
    $scope.clickTab = (index) ->
      # backボタンを隠す
      $ionicNavBarDelegate.showBackButton false
      # historyデータを削除する
      $ionicHistory.clearHistory();
      # $ionicHistory.clearCache();
      if index == 0
        $rootScope.appTitle = $translate.instant('SEO.TITLE.HOME')
        $location.path('/app').search('keywords', null)
        $rootScope.currentType = 'home'
      else if index == 1
        $rootScope.appTitle = $translate.instant('SEO.TITLE.MAP')
        $location.path('/app/map').search('keywords', null)
        $rootScope.currentType = 'map'
      else if index == 2
        $rootScope.appTitle = $translate.instant('SEO.TITLE.SHOP')
        $location.path('/app/shops').search('keywords', null)
        $rootScope.currentType = 'shops'
