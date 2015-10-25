'use strict'

###*
 # @ngdoc function
 # @name frontApp.controller:HeaderCtrl
 # @description
 # # HeaderCtrl
 # Controller of the frontApp
###
angular.module "frontApp"
  .controller "HeaderCtrl", ($scope, $rootScope, $timeout, $ionicSideMenuDelegate, $ionicModal, $sessionStorage, Api, toaster, Const) ->

    # 変数設定
    $ionicModal.fromTemplateUrl('views/parts/modal-login.html',
      scope: $scope
      animation: 'slide-in-up').then (modal) ->
      $scope.modal = modal
      return

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
    $scope.openModal = ->
      $scope.modal.show()
      $ionicSideMenuDelegate.toggleRight();

    $scope.hideModal = ->
      $scope.modal.hide()

    $scope.toggleRight = ->
      $ionicSideMenuDelegate.toggleRight();

    $scope.doLogin = ->
      obj =
        "user[email]": $scope.input.email
        "user[password]": $scope.input.password

      Api.postJson(obj, Const.API.LOGIN).then (res) ->
        $scope.modal.hide()
        clearInput()
        $sessionStorage['email'] = res.data.email
        $sessionStorage['token'] = res.data.authentication_token
        $rootScope.isLogin = true
        # toast表示
        toaster.pop
          type: 'success',
          title: Const.MSG.LOGED_IN,
          showCloseButton: true

    $scope.doLogout = ->
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

    $scope.doSignUp = ->
      obj =
        "user[email]": $scope.input.email
        "user[password]": $scope.input.password
        "user[password_confirmation]": $scope.input.password_confirmation

      Api.saveJson(obj, Const.API.USER, Const.METHOD.POST).then (res) ->
        $scope.doLogin()
        $scope.modal.hide()
        clearInput()
        # toast表示
        toaster.pop
          type: 'success',
          title: Const.MSG.SINGED_UP,
          showCloseButton: true

    $scope.closeMenu = ->
      $ionicSideMenuDelegate.toggleRight();
