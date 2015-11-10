(function() {
  'use strict';

  /**
    * @ngdoc function
    * @name frontApp.controller:MainCtrl
    * @description
    * # MainCtrl
    * Controller of the frontApp
   */
  angular.module("frontApp").controller("MainCtrl", function($scope, $ionicSideMenuDelegate, Api, Const) {
    var categoryObj;
    $scope.targetCategoryId = null;
    $scope.page = 1;
    $scope.noMoreLoad = false;
    categoryObj = {
      type: "PostCategory"
    };
    Api.getJson(categoryObj, Const.API.CATEGORY).then(function(res) {
      return $scope.categories = res.data;
    });
    $scope.init = function() {
      var obj;
      obj = {
        per: 20,
        page: 1
      };
      return Api.getJson(obj, Const.API.POST).then(function(res) {
        $scope.posts = res.data;
        $scope.$broadcast('scroll.refreshComplete');
        return $scope.targetCategoryId = null;
      });
    };
    $scope.search = function(categoryId) {
      var obj;
      if (categoryId === $scope.targetCategoryId) {
        $scope.targetCategoryId = null;
        obj = "";
      } else {
        $scope.targetCategoryId = categoryId;
        obj = {
          category: categoryId
        };
      }
      return Api.getJson(obj, Const.API.POST).then(function(res) {
        return $scope.posts = res.data;
      });
    };
    return $scope.loadMoreData = function() {
      var obj;
      $scope.page += 1;
      obj = {
        per: 20,
        page: $scope.page,
        category: $scope.targetCategoryId
      };
      return Api.getJson(obj, Const.API.POST).then(function(res) {
        if (res.data.length === 0) {
          return $scope.noMoreLoad = true;
        } else {
          angular.forEach(res.data, function(data, i) {
            return $scope.posts.push(data);
          });
          return $scope.$broadcast('scroll.infiniteScrollComplete');
        }
      });
    };
  });

}).call(this);

//# sourceMappingURL=main.js.map
