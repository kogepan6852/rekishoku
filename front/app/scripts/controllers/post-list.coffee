'use strict'

###*
 # @ngdoc function
 # @name frontApp.controller:PostListCtrl
 # @description
 # # PostListCtrl
 # Controller of the frontApp
###
angular.module "frontApp"
  .controller "PostListCtrl", ["$scope","$ionicSideMenuDelegate", "$ionicModal", "Api", ($scope, $ionicSideMenuDelegate, $ionicModal, Api) ->


    $ionicModal.fromTemplateUrl('views/modal-post.html',
      scope: $scope
      animation: 'slide-in-up').then (modal) ->
      $scope.modal = modal
      return

    $scope.openModal = ->
      $scope.modal.show()

    $scope.editting = false
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

    $scope.new = ->
      location.href = '#/post'

    $scope.edit = ->
      $scope.editting = !$scope.editting

]