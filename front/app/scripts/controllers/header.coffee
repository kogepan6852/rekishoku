'use strict'

###*
 # @ngdoc function
 # @name frontApp.controller:HeaderCtrl
 # @description
 # # HeaderCtrl
 # Controller of the frontApp
###
angular.module "frontApp"
  .controller "HeaderCtrl", ($scope, $rootScope, $timeout, $ionicSideMenuDelegate, $ionicModal, $ionicPopup, $sessionStorage, Api, toaster, Const) ->

    # 変数設定
    $ionicModal.fromTemplateUrl('views/parts/modal-login.html',
      scope: $scope
      animation: 'slide-in-up').then (modalLogin) ->
      $scope.modalLogin = modalLogin

    $ionicModal.fromTemplateUrl('views/parts/modal-profile-edit.html',
      scope: $scope
      animation: 'slide-in-up').then (modalProfileEdit) ->
      $scope.modalProfileEdit = modalProfileEdit

    if !$sessionStorage['token']
      $rootScope.isLogin = false
    else
      $rootScope.isLogin = true


    # 初期処理
    clearInput = ->
      input =
        email: ""
        password: ""
        password_confirmation: ""
      $scope.input = input
      # 画像を削除する
      angular.forEach angular.element("input[type='file']"), (inputElem) ->
        angular.element(inputElem).val null

    clearInput()

    if $sessionStorage['email']
      $scope.input.email = $sessionStorage['email']

    # Function
    $scope.openModalLogin = ->
      $scope.modalLogin.show()

    $scope.hideModalLogin = ->
      $scope.modalLogin.hide()

    $scope.openModalProfileEdit = ->
      userId = $sessionStorage['user_id']
      path = Const.API.USER + '/' + userId + '.json'
      Api.getJson("", path).then (res) ->
        $scope.input =
          email: res.data.email
          username: res.data.username
          first_name: res.data.first_name
          last_name: res.data.last_name
          profile: res.data.profile
          image: res.data.image
        $scope.srcUrl = res.data.image.image.thumb.url
        $scope.modalProfileEdit.show()

    $scope.hideModalProfileEdit = (targetForm) ->
      clearInput()
      targetForm.$setPristine()
      $scope.modalProfileEdit.hide()

    $scope.toggleRight = ->
      $ionicSideMenuDelegate.toggleRight();

    $scope.doLogin = ->
      obj =
        "user[email]": $scope.input.email
        "user[password]": $scope.input.password

      Api.postJson(obj, Const.API.LOGIN).then (res) ->
        $ionicSideMenuDelegate.toggleRight();
        $scope.modalLogin.hide()
        clearInput()

        $sessionStorage['email'] = res.data.email
        $sessionStorage['token'] = res.data.authentication_token
        $sessionStorage['user_id'] = res.data.id
        $rootScope.isLogin = true
        # toast表示
        toaster.pop
          type: 'success',
          title: Const.MSG.LOGED_IN,
          showCloseButton: true

    $scope.doLogout = ->
      $ionicPopup.show(
        title: 'ログアウトしてよろしいですか？'
        scope: $scope
        buttons: [
          { text: 'キャンセル' }
          {
            text: '<b>OK</b>'
            type: 'button-dark'
            onTap: (e) ->
              $rootScope.isLogin = false
              accessKey =
                email: $sessionStorage['email']
                token: $sessionStorage['token']

              Api.logOut(accessKey, Const.API.LOGOUT).then (res) ->
                $ionicSideMenuDelegate.toggleRight();
                clearInput()
                # login情報の削除
                delete $sessionStorage['token']
                delete $sessionStorage['email']
                delete $sessionStorage['user_id']
                if $rootScope.postListInit
                  $rootScope.postListInit()
          }
        ])

    $scope.doSignUp = ->
      obj =
        "user[email]": $scope.input.email
        "user[password]": $scope.input.password
        "user[password_confirmation]": $scope.input.password_confirmation

      Api.saveJson(obj, Const.API.USER, Const.METHOD.POST).then (res) ->
        $scope.doLogin()
        $scope.modalLogin.hide()
        clearInput()
        # toast表示
        toaster.pop
          type: 'success',
          title: Const.MSG.SINGED_UP,
          showCloseButton: true

    $scope.closeMenu = ->
      $ionicSideMenuDelegate.toggleRight();

    $scope.saveProfile = (targetForm) ->
        fd = new FormData
        userId = $sessionStorage['user_id']
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
          $ionicSideMenuDelegate.toggleRight();
          toaster.pop
            type: 'success',
            title: 'プロフィールを保存しました',
            showCloseButton: true

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
