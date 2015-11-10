(function() {
  'use strict';

  /**
    * @ngdoc function
    * @name frontApp.controller:WritersCtrl
    * @description
    * WritersCtrl
    * Controller of the frontApp
   */
  angular.module("frontApp").controller("WritersCtrl", function($scope, $ionicSideMenuDelegate, Api, Const) {
    return $scope.init = function() {
      return Api.getJson("", Const.API.USER + '.json').then(function(res) {
        $scope.users = res.data;
        return $scope.$broadcast('scroll.refreshComplete');
      });
    };
  });

}).call(this);

//# sourceMappingURL=writers.js.map
