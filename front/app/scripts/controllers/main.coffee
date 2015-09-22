'use strict'

###*
 # @ngdoc function
 # @name frontApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the frontApp
###
angular.module "frontApp"
  .controller "MainCtrl", ["$scope","$ionicSideMenuDelegate", "Api", ($scope, $ionicSideMenuDelegate, Api) ->

    clearInput = ->
      input =
        title: ""
        content: ""
        quotation_url: ""
        quotation_name: ""
      $scope.input = input

    clearInput()

    Api.getPeople().then (res) ->
      $scope.results = res.data

    $scope.doPost = ->

      obj =
        "post[title]": $scope.input.title
        "post[content]": $scope.input.content
        "post[quotation_url]": $scope.input.quotation_url
        "post[quotation_name]": $scope.input.quotation_name

      Api.postPeople(obj).then (res) ->
        $scope.results.push res.data
        clearInput()

    $scope.doDelete = (index) ->
      Api.deletePeople($scope.results[index].id).then (res) ->
        $scope.results.splice index, 1

]