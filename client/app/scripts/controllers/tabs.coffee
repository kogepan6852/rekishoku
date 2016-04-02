'use strict'

###*
 # @ngdoc function
 # @name frontApp.controller:TabsCtrl
 # @description
 # WritersCtrl
 # Controller of the frontApp
###
angular.module "frontApp"
  .controller "TabsCtrl", ($scope, $rootScope, $ionicTabsDelegate, $location, $ionicNavBarDelegate, $ionicHistory) ->

    # Function
    $scope.clickTab = (index) ->
      # backボタンを隠す
      $ionicNavBarDelegate.showBackButton false
      # historyデータを削除する
      $ionicHistory.clearHistory();
      # $ionicHistory.clearCache();
      if index == 0
        $location.path('/app').search('keywords', null)
        $rootScope.currentType = 'home'
      else if index == 1
        $location.path('/app/map').search('keywords', null)
        $rootScope.currentType = 'map'
      else if index == 2
        $location.path('/app/shops').search('keywords', null)
        $rootScope.currentType = 'shops'
