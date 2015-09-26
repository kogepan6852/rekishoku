'use strict'

###*
 # @ngdoc function
 # @name frontApp.controller:PostListCtrl
 # @description
 # # PostListCtrl
 # Controller of the frontApp
###
angular.module "frontApp"
  .controller "PostListCtrl", ($scope, $ionicSideMenuDelegate, $ionicModal, $sessionStorage, Api) ->

    # 変数設定
    $ionicModal.fromTemplateUrl('views/modal-post.html',
      scope: $scope
      animation: 'slide-in-up').then (modal) ->
      $scope.modal = modal
      return

    $scope.categories = [
      {slug:'episode', name:'歴食エピソード'},
      {slug:'experience', name:'歴食体験'},
      {slug:'information', name:'歴食ニュース'}
    ]

    # 初期処理
    clearInput = ->
      input =
        title: ""
        content: ""
        quotation_url: ""
        quotation_name: ""
        category: ""
        authentication_token: $sessionStorage['token']
      $scope.input = input

    clearInput()

    accessKey =
      email: $sessionStorage['email']
      token: $sessionStorage['token']

    if ($sessionStorage['token'])
      Api.getPostList(accessKey).then (res) ->
        $scope.results = res.data

    # Function
    $scope.openModal = ->
      $scope.modal.show()

    $scope.editting = false

    $scope.doPost = ->
      obj =
        "post[title]": $scope.input.title
        "post[content]": $scope.input.content
        "post[quotation_url]": $scope.input.quotation_url
        "post[quotation_name]": $scope.input.quotation_name
        "slug": $scope.input.category.slug
        "email": $sessionStorage['email']
        "token": $sessionStorage['token']

      Api.postPostList(obj).then (res) ->
        $scope.results.push res.data
        clearInput()

    $scope.doDelete = (index) ->
      Api.deletePostList($scope.results[index].id).then (res) ->
        $scope.results.splice index, 1

    $scope.new = ->
      location.href = '#/post'

    $scope.edit = ->
      $scope.editting = !$scope.editting
