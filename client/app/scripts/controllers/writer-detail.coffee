'use strict'

###*
 # @ngdoc function
 # @name frontApp.controller:WriterDetailCtrl
 # @description
 # WritersCtrl
 # Controller of the frontApp
###
angular.module "frontApp"
  .controller "WriterDetailCtrl", ($scope, $rootScope, $stateParams, $ionicModal, $sessionStorage, $controller, $state, Api, Const, toaster) ->

    # Controllerの継承
    $controller 'BaseCtrl', $scope: $scope

    # 変数設定
    $rootScope.isHideTab = true

    # setting
    $ionicModal.fromTemplateUrl('views/parts/modal-profile-edit.html',
      scope: $scope
      animation: 'slide-in-up').then (modalProfileEdit) ->
      $scope.modalProfileEdit = modalProfileEdit
    $scope.isLoginUser = false

    # initialize
    clearInput = ->
      input =
        email: ""
        password: ""
        password_confirmation: ""
      $scope.input = input
      # 画像を削除する
      angular.forEach angular.element("input[type='file']"), (inputElem) ->
        angular.element(inputElem).val null

    $scope.writersInit = ->
      clearInput()
      accessKey =
        email: $sessionStorage['email']
        token: $sessionStorage['token']
      path = Const.API.USER + '/' + $stateParams.id
      Api.getJson(accessKey, path).then (res) ->
        $scope.user = res.data.user
        $scope.posts = res.data.posts

      if String($stateParams.id) == String($sessionStorage['user_id'])
        $scope.isLoginUser = true

      # 現在タブの判定
      if $state.is('tabs.post-writer')
        $scope.nowTab = 'post'
      else if $state.is('tabs.map-writer')
        $scope.nowTab = 'map'
      else if $state.is('tabs.shop-writer')
        $scope.nowTab = 'shop'
      else
        $scope.nowTab = 'other'

    # Function
    $scope.openModalProfileEdit = ->
      $scope.input =
        email: $scope.user.email
        username: $scope.user.username
        first_name: $scope.user.first_name
        last_name: $scope.user.last_name
        profile: $scope.user.profile
        image: $scope.user.image
      $scope.srcUrl = $scope.user.image.image.thumb.url
      $scope.modalProfileEdit.show()

    $scope.hideModalProfileEdit = (targetForm) ->
      clearInput()
      targetForm.$setPristine()
      $scope.modalProfileEdit.hide()

    $scope.saveProfile = (targetForm) ->
        fd = new FormData
        userId = $sessionStorage['user_id']
        fd.append 'token', $sessionStorage['token']
        fd.append 'email', $sessionStorage['email']
        fd.append 'user[id]', userId
        fd.append 'user[username]', $scope.input.username.trim()
        fd.append 'user[last_name]', $scope.input.last_name.trim()
        fd.append 'user[first_name]', $scope.input.first_name.trim()
        fd.append 'user[profile]', $scope.input.profile.trim()
        fd.append 'user[image]', $scope.input.file
        if $scope.input.file then fd.append 'user[image]', $scope.input.file

        # データ登録
        url = Const.API.USER+'/'+userId
        method = Const.METHOD.PATCH

        Api.saveFormData(fd, url, method).then (res) ->
          clearInput()
          targetForm.$setPristine()
          $scope.modalProfileEdit.hide()
          toaster.pop
            type: 'success',
            title: 'プロフィールを保存しました',
            showCloseButton: true

          $scope.writersInit()

    # 変化を監視してメイン画像を読み込み＋表示を実行
    $scope.$watch 'input.file', (file) ->
      $scope.srcUrl = undefined
      #画像ファイルじゃなければ何もしない
      if !file or !file.type.match('image.*')
        return
      reader = new FileReader
      reader.onload = ->
        $scope.$apply ->
          $scope.srcUrl = reader.result
      reader.readAsDataURL file
