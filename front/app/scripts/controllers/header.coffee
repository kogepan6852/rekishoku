'use strict'

###*
 # @ngdoc function
 # @name frontApp.controller:HeaderCtrl
 # @description
 # # HeaderCtrl
 # Controller of the frontApp
###
angular.module "frontApp"
  .controller "HeaderCtrl", ($scope, $rootScope, $ionicSideMenuDelegate, $ionicModal, $sessionStorage, Api, toaster) ->

    # 変数設定
    $ionicModal.fromTemplateUrl('views/modal-login.html',
      scope: $scope
      animation: 'slide-in-up').then (modal) ->
      $scope.modal = modal
      return

    # 初期処理
    clearInput = ->
      input =
        email: ""
        password: ""
        password_confirmation: ""
      $scope.input = input

    clearInput()

    # Function
    $scope.openModal = ->
      $scope.modal.show()
      $ionicSideMenuDelegate.toggleRight();

    $scope.toggleRight = ->
      $ionicSideMenuDelegate.toggleRight();

    $scope.doLogin = ->

      obj =
        "user[email]": $scope.input.email
        "user[password]": $scope.input.password

      Api.getAccessToken(obj).then (res) ->
        $scope.modal.hide()
        clearInput()
        $sessionStorage['email'] = res.data.email
        $sessionStorage['token'] = res.data.authentication_token
        $rootScope.isLogin = true
        toaster.pop
          type: 'success',
          title: 'ログインしました',
          showCloseButton: true


    $scope.doLogout = ->
      $ionicSideMenuDelegate.toggleRight();
      clearInput()
      delete $sessionStorage['token']
      $rootScope.isLogin = false
      toaster.pop
        type: 'success',
        title: 'ログアウトしました',
        showCloseButton: true


    $scope.doSignUp = ->
      obj =
        "user[email]": $scope.input.email
        "user[password]": $scope.input.password
        "user[password_confirmation]": $scope.input.password_confirmation

      Api.postUser(obj).then (res) ->
        $scope.modal.hide()
        clearInput()
