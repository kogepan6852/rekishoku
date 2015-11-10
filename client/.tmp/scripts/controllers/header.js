(function() {
  'use strict';

  /**
    * @ngdoc function
    * @name frontApp.controller:HeaderCtrl
    * @description
    * # HeaderCtrl
    * Controller of the frontApp
   */
  angular.module("frontApp").controller("HeaderCtrl", function($scope, $rootScope, $timeout, $ionicSideMenuDelegate, $ionicModal, $ionicPopup, $sessionStorage, $location, Api, toaster, Const) {
    var clearInput;
    $ionicModal.fromTemplateUrl('views/parts/modal-login.html', {
      scope: $scope,
      animation: 'slide-in-up'
    }).then(function(modalLogin) {
      return $scope.modalLogin = modalLogin;
    });
    if (!$sessionStorage['token']) {
      $rootScope.isLogin = false;
    } else {
      $rootScope.isLogin = true;
    }
    $scope.showLogin = false;
    if ($location.search()["showLogin"]) {
      $scope.showLogin = true;
    }
    clearInput = function() {
      var input;
      input = {
        email: "",
        password: "",
        password_confirmation: ""
      };
      return $scope.input = input;
    };
    clearInput();
    if ($sessionStorage['email']) {
      $scope.input.email = $sessionStorage['email'];
    }
    $scope.openModalLogin = function() {
      return $scope.modalLogin.show();
    };
    $scope.hideModalLogin = function() {
      return $scope.modalLogin.hide();
    };
    $scope.toggleRight = function() {
      return $ionicSideMenuDelegate.toggleRight();
    };
    $scope.doLogin = function() {
      var obj;
      obj = {
        "user[email]": $scope.input.email,
        "user[password]": $scope.input.password
      };
      return Api.postJson(obj, Const.API.LOGIN).then(function(res) {
        $ionicSideMenuDelegate.toggleRight();
        $scope.modalLogin.hide();
        clearInput();
        $sessionStorage['email'] = res.data.email;
        $sessionStorage['token'] = res.data.authentication_token;
        $sessionStorage['user_id'] = res.data.id;
        $rootScope.isLogin = true;
        return toaster.pop({
          type: 'success',
          title: Const.MSG.LOGED_IN,
          showCloseButton: true
        });
      });
    };
    $scope.doLogout = function() {
      return $ionicPopup.show({
        title: 'ログアウトしてよろしいですか？',
        scope: $scope,
        buttons: [
          {
            text: 'キャンセル'
          }, {
            text: '<b>OK</b>',
            type: 'button-dark',
            onTap: function(e) {
              var accessKey;
              $rootScope.isLogin = false;
              accessKey = {
                email: $sessionStorage['email'],
                token: $sessionStorage['token']
              };
              return Api.logOut(accessKey, Const.API.LOGOUT).then(function(res) {
                $ionicSideMenuDelegate.toggleRight();
                clearInput();
                delete $sessionStorage['token'];
                delete $sessionStorage['email'];
                delete $sessionStorage['user_id'];
                return $location.path('/home/');
              });
            }
          }
        ]
      });
    };
    $scope.doSignUp = function() {
      var obj;
      obj = {
        "user[email]": $scope.input.email,
        "user[password]": $scope.input.password,
        "user[password_confirmation]": $scope.input.password_confirmation
      };
      return Api.saveJson(obj, Const.API.USER, Const.METHOD.POST).then(function(res) {
        $scope.doLogin();
        $scope.modalLogin.hide();
        clearInput();
        return toaster.pop({
          type: 'success',
          title: Const.MSG.SINGED_UP,
          showCloseButton: true
        });
      });
    };
    $scope.closeMenu = function() {
      return $ionicSideMenuDelegate.toggleRight();
    };
    return $scope.moveToWriterDetail = function() {
      var userId;
      userId = $sessionStorage['user_id'];
      $location.path('/writer/' + userId);
      return $ionicSideMenuDelegate.toggleRight();
    };
  });

}).call(this);

//# sourceMappingURL=header.js.map
