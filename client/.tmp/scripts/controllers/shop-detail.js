(function() {
  'use strict';

  /**
    * @ngdoc function
    * @name frontApp.controller:ShopDetailCtrl
    * @description
    * # PostDetailCtrl
    * Controller of the frontApp
   */
  angular.module('frontApp').controller("ShopDetailCtrl", function($scope, $stateParams, $sessionStorage, Api, Const) {
    $scope.targetId = $stateParams.id;
    return Api.getJson("", Const.API.SHOP + '/' + $stateParams.id + '.json').then(function(res) {
      var ret, shops;
      $scope.shop = res.data.shop;
      $scope.categories = res.data.categories;
      $scope.posts = res.data.posts;
      $scope.map = {
        center: {
          latitude: res.data.shop.latitude,
          longitude: res.data.shop.longitude
        },
        zoom: 14,
        bounds: {}
      };
      $scope.options = {
        scrollwheel: false,
        minZoom: 11
      };
      shops = [];
      ret = {
        latitude: res.data.shop.latitude,
        longitude: res.data.shop.longitude,
        showWindow: true,
        title: res.data.shop.name,
        url: res.data.shop.image.thumb.url
      };
      ret['id'] = res.data.shop.id;
      shops.push(ret);
      return $scope.targetMarkers = shops;
    });
  });

}).call(this);

//# sourceMappingURL=shop-detail.js.map
