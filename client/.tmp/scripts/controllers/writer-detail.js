(function() {
  'use strict';

  /**
    * @ngdoc function
    * @name frontApp.controller:WriterDetailCtrl
    * @description
    * WritersCtrl
    * Controller of the frontApp
   */
  angular.module("frontApp").controller("WriterDetailCtrl", function($scope, $stateParams, $ionicModal, $sessionStorage, Api, Const, toaster) {
    var clearInput;
    $ionicModal.fromTemplateUrl('views/parts/modal-profile-edit.html', {
      scope: $scope,
      animation: 'slide-in-up'
    }).then(function(modalProfileEdit) {
      return $scope.modalProfileEdit = modalProfileEdit;
    });
    $scope.isLoginUser = false;
    clearInput = function() {
      var input;
      input = {
        email: "",
        password: "",
        password_confirmation: ""
      };
      $scope.input = input;
      return angular.forEach(angular.element("input[type='file']"), function(inputElem) {
        return angular.element(inputElem).val(null);
      });
    };
    $scope.writersInit = function() {
      var path;
      clearInput();
      path = Const.API.USER + '/' + $stateParams.id + '.json';
      Api.getJson("", path).then(function(res) {
        $scope.user = res.data.user;
        return $scope.posts = res.data.posts;
      });
      if (String($stateParams.id) === String($sessionStorage['user_id'])) {
        return $scope.isLoginUser = true;
      }
    };
    $scope.openModalProfileEdit = function() {
      var accessKey, path, userId;
      accessKey = {
        email: $sessionStorage['email'],
        token: $sessionStorage['token']
      };
      userId = $sessionStorage['user_id'];
      path = Const.API.USER + '/' + userId + '.json';
      return Api.getJson(accessKey, path).then(function(res) {
        $scope.input = {
          email: res.data.email,
          username: res.data.username,
          first_name: res.data.first_name,
          last_name: res.data.last_name,
          profile: res.data.profile,
          image: res.data.image
        };
        $scope.srcUrl = res.data.image.image.thumb.url;
        return $scope.modalProfileEdit.show();
      });
    };
    $scope.hideModalProfileEdit = function(targetForm) {
      clearInput();
      targetForm.$setPristine();
      return $scope.modalProfileEdit.hide();
    };
    $scope.saveProfile = function(targetForm) {
      var fd, method, url, userId;
      fd = new FormData;
      userId = $sessionStorage['user_id'];
      fd.append('user[id]', userId);
      fd.append('user[username]', $scope.input.username.trim());
      fd.append('user[last_name]', $scope.input.last_name.trim());
      fd.append('user[first_name]', $scope.input.first_name.trim());
      fd.append('user[profile]', $scope.input.profile.trim());
      fd.append('user[image]', $scope.input.file);
      if ($scope.input.file) {
        fd.append('user[image]', $scope.input.file);
      }
      url = Const.API.USER + '/' + userId;
      method = Const.METHOD.PATCH;
      return Api.saveFormData(fd, url, method).then(function(res) {
        clearInput();
        targetForm.$setPristine();
        $scope.modalProfileEdit.hide();
        toaster.pop({
          type: 'success',
          title: 'プロフィールを保存しました',
          showCloseButton: true
        });
        return $scope.writersInit();
      });
    };
    return $scope.$watch('input.file', function(file) {
      var reader;
      $scope.srcUrl = void 0;
      if (!file || !file.type.match('image.*')) {
        return;
      }
      reader = new FileReader;
      reader.onload = function() {
        return $scope.$apply(function() {
          return $scope.srcUrl = reader.result;
        });
      };
      return reader.readAsDataURL(file);
    });
  });

}).call(this);

//# sourceMappingURL=writer-detail.js.map
