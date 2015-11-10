(function() {
  "use strict";
  angular.module("frontApp").factory("Api", function($http, $ionicPopup, $ionicLoading, toaster, Const, config) {
    var errorHandring, host;
    host = config.url.api;
    errorHandring = function(data) {
      var alertPopup;
      if (data.error) {
        alertPopup = $ionicPopup.alert({
          title: data.error,
          type: 'button-dark'
        });
        return alertPopup.then(function(res) {});
      } else {
        alertPopup = $ionicPopup.alert({
          title: '通信エラーが発生しました',
          type: 'button-dark'
        });
        return alertPopup.then(function(res) {});
      }
    };
    return {
      getJson: function(obj, path) {
        $ionicLoading.show({
          template: '<ion-spinner icon="ios"></ion-spinner><br>Loading...',
          delay: 500
        });
        return $http({
          method: 'GET',
          url: host + path,
          params: obj
        }).success(function(data, status, headers, config) {
          return $ionicLoading.hide();
        }).error(function(data, status, headers, config) {
          $ionicLoading.hide();
          return errorHandring(data);
        });
      },
      postJson: function(obj, path) {
        $ionicLoading.show({
          template: '<ion-spinner icon="ios"></ion-spinner><br>Loading...',
          delay: 500
        });
        return $http({
          method: 'POST',
          url: host + path,
          data: obj
        }).success(function(data, status, headers, config) {
          return $ionicLoading.hide();
        }).error(function(data, status, headers, config) {
          $ionicLoading.hide();
          return errorHandring(data);
        });
      },
      saveJson: function(obj, path, method) {
        $ionicLoading.show({
          template: '<ion-spinner icon="ios"></ion-spinner><br>Loading...'
        });
        return $http({
          method: method,
          url: host + path + ".json",
          data: obj
        }).success(function(data, status, headers, config) {
          return $ionicLoading.hide();
        }).error(function(data, status, headers, config) {
          $ionicLoading.hide();
          return errorHandring(data);
        });
      },
      saveFormData: function(fd, path, method) {
        $ionicLoading.show({
          template: '<ion-spinner icon="ios"></ion-spinner><br>Loading...'
        });
        return $http({
          method: method,
          url: host + path + ".json",
          transformRequest: null,
          headers: {
            'Content-type': void 0
          },
          data: fd
        }).success(function(data, status, headers, config) {
          return $ionicLoading.hide();
        }).error(function(data, status, headers, config) {
          $ionicLoading.hide();
          return errorHandring(data);
        });
      },
      deleteJson: function(obj, id, path) {
        $ionicLoading.show({
          template: '<ion-spinner icon="ios"></ion-spinner><br>Loading...'
        });
        return $http({
          method: 'DELETE',
          url: host + path + "/" + id + ".json",
          params: obj
        }).success(function(data, status, headers, config) {
          return $ionicLoading.hide();
        }).error(function(data, status, headers, config) {
          $ionicLoading.hide();
          return errorHandring(data);
        });
      },
      logOut: function(obj, path) {
        return $http({
          method: 'DELETE',
          url: host + path,
          params: obj
        }).success(function(data, status, headers, config) {
          return toaster.pop({
            type: 'success',
            title: 'ログアウトしました',
            showCloseButton: true
          });
        }).error(function(data, status, headers, config) {
          return errorHandring(data);
        });
      }
    };
  });

}).call(this);

//# sourceMappingURL=api.js.map
