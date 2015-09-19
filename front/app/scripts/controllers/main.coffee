'use strict'

###*
 # @ngdoc function
 # @name frontApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the frontApp
###
angular.module("frontApp")
  .controller "MainCtrl", ["$scope", "Api", ($scope, Api) ->

    clearInput = ->
      $scope.new_title = ""
      $scope.new_content = ""
      $scope.new_quotation_url = ""
      $scope.new_quotation_name = ""

    clearInput()

    Api.getPeople().then (res) ->
      $scope.results = res.data

    $scope.doPost = ->

      obj =
        "post[title]": $scope.new_title
        "post[content]": $scope.new_content
        "post[quotation_url]": $scope.new_quotation_url
        "post[quotation_name]": $scope.new_quotation_name

      Api.postPeople(obj).then (res) ->
        $scope.results.push res.data
        clearInput()

    $scope.doDelete = (index) ->
      Api.deletePeople($scope.results[index].id).then (res) ->
        $scope.results.splice index, 1
]