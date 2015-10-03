'use strict'

###*
 # @ngdoc function
 # @name frontApp.controller:PostListCtrl
 # @description
 # # PostListCtrl
 # Controller of the frontApp
###
angular.module "frontApp"
  .controller "PostListCtrl", ($scope, $ionicSideMenuDelegate, $ionicModal, $sessionStorage, Api, $http) ->

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
        file: ""
        content: ""
        quotation_url: ""
        quotation_name: ""
        category: $scope.categories[0]
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

    $scope.doPost = (postForm) ->
      #formdata
      fd = new FormData
      fd.append 'token', $sessionStorage['token']
      fd.append 'email', $sessionStorage['email']
      fd.append 'slug', $scope.input.category.slug
      fd.append 'post[title]', $scope.input.title
      fd.append 'post[image]', $scope.input.file
      fd.append 'post[content]', $scope.input.content
      fd.append 'post[quotation_url]', $scope.input.quotation_url
      fd.append 'post[quotation_name]', $scope.input.quotation_name
      Api.postPostList(fd).then (res) ->
        $scope.results.push res.data
        clearInput()
        postForm.$setPristine()
        $scope.modal.hide()


    $scope.doDelete = (index) ->
      accessKey =
        email: $sessionStorage['email']
        token: $sessionStorage['token']

      Api.deletePostList($scope.results[index].id, accessKey).then (res) ->
        $scope.results.splice index, 1

    $scope.new = ->
      location.href = '#/post'

    $scope.edit = ->
      $scope.editting = !$scope.editting

    #変化を監視して画像読み込み＋表示を実行
    $scope.$watch 'input.file', (file) ->
      $scope.srcUrl = undefined
      #画像ファイルじゃなければ何もしない
      if !file or !file.type.match('image.*')
        return
      #new FileReader API
      reader = new FileReader
      #callback

      reader.onload = ->
        $scope.$apply ->
          $scope.srcUrl = reader.result

      #read as url(reader.result = url)
      reader.readAsDataURL file
