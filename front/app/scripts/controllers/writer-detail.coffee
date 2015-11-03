'use strict'

###*
 # @ngdoc function
 # @name frontApp.controller:WriterDetailCtrl
 # @description
 # WritersCtrl
 # Controller of the frontApp
###
angular.module "frontApp"
  .controller "WriterDetailCtrl", ($scope, $stateParams, Api, Const) ->

    # setting

    # initialize
    path = Const.API.USER + '/' + $stateParams.id + '.json'
    Api.getJson("", path).then (res) ->
      $scope.user = res.data.user
      $scope.posts = res.data.posts

    # Function
