'use strict'

###*
 # @ngdoc function
 # @name frontApp.controller:TabsCtrl
 # @description
 # WritersCtrl
 # Controller of the frontApp
###
angular.module "frontApp"
  .controller "TabsCtrl", ($scope, $ionicTabsDelegate, $location) ->

    # Function
    $scope.clickTab = (index) ->
      if index == 0
        $location.path('/home').search('keywords', null)
      else if index == 1
        $location.path('/map').search('keywords', null)
      else if index == 2
        $location.path('/shops').search('keywords', null)
