(function() {
  'use strict';

  /**
    * @ngdoc function
    * @name frontApp.controller:PostDetailCtrl
    * @description
    * # PostDetailCtrl
    * Controller of the frontApp
   */
  angular.module('frontApp').controller("PostDetailCtrl", function($scope, $stateParams, $ionicHistory, $sessionStorage, Api, Const) {
    var path;
    $scope.targetId = $stateParams.id;
    path = Const.API.POST + '/' + $stateParams.id;
    Api.getJson("", path).then(function(res) {
      $scope.post = res.data.post;
      $scope.shops = res.data.shops;
      return Api.getJson("", Const.API.POST_DETSIL + '/' + res.data.post.id).then(function(res) {
        return $scope.postDetails = res.data;
      });
    });
    return $scope.myGoBack = function() {
      return $ionicHistory.goBack();
    };
  });

}).call(this);

//# sourceMappingURL=post-detail.js.map
