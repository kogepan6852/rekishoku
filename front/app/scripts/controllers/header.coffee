'use strict'

###*
 # @ngdoc function
 # @name frontApp.controller:HeaderCtrl
 # @description
 # # HeaderCtrl
 # Controller of the frontApp
###
angular.module "frontApp"
  .controller "HeaderCtrl", ($scope, $rootScope, $timeout, $ionicSideMenuDelegate, $ionicModal, $ionicPopup, $sessionStorage, $location, Api, toaster, Const) ->

    # 変数設定
    $ionicModal.fromTemplateUrl('views/parts/modal-login.html',
      scope: $scope
      animation: 'slide-in-up').then (modalLogin) ->
      $scope.modalLogin = modalLogin

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

    clearInput()

    if $sessionStorage['email']
      $scope.input.email = $sessionStorage['email']

    # Function
    $scope.openModalLogin = ->
      $scope.modalLogin.show()

    $scope.hideModalLogin = ->
      $scope.modalLogin.hide()

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

    $scope.moveToWriterDetail = ->
      userId = $sessionStorage['user_id']
      $location.path('/writer/' + userId);
      $ionicSideMenuDelegate.toggleRight();
