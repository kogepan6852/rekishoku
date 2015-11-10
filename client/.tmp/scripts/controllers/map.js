(function() {
  'use strict';

  /**
    * @ngdoc function
    * @name frontApp.controller:AboutCtrl
    * @description
    * # AboutCtrl
    * Controller of the frontApp
   */
  angular.module('frontApp').controller('MapCtrl', function($scope, $rootScope, $window, $sessionStorage, $ionicSideMenuDelegate, Api, toaster, BaseService, Const) {
    var defaultZoom, setMapData, targetDistance;
    $scope.input = {
      address: null
    };
    defaultZoom = 14;
    targetDistance = BaseService.calMapDistance(defaultZoom);
    $scope.map = {
      center: {
        latitude: 35.6813818,
        longitude: 139.7660838
      },
      zoom: defaultZoom,
      bounds: {}
    };
    $scope.options = {
      scrollwheel: false,
      minZoom: 11
    };
    $scope.events = {
      dragstart: function(cluster, clusterModels) {
        return $ionicSideMenuDelegate.canDragContent(false);
      },
      dragend: function(cluster, clusterModels) {
        var obj;
        $ionicSideMenuDelegate.canDragContent(true);
        obj = {
          latitude: cluster.center.G,
          longitude: cluster.center.K,
          shopDistance: targetDistance
        };
        return setMapData(obj);
      },
      zoom_changed: function(cluster, clusterModels) {
        var obj;
        targetDistance = BaseService.calMapDistance(cluster.zoom);
        obj = {
          placeAddress: $scope.input.address,
          shopDistance: targetDistance
        };
        return setMapData(obj);
      }
    };
    $scope.targetMarkers = [];
    $scope.init = function() {
      if (navigator.geolocation) {
        return navigator.geolocation.getCurrentPosition((function(position) {
          var obj;
          $scope.map.center.latitude = position.coords.latitude;
          $scope.map.center.longitude = position.coords.longitude;
          obj = {
            latitude: position.coords.latitude,
            longitude: position.coords.longitude,
            shopDistance: targetDistance
          };
          return setMapData(obj);
        }), function(e) {
          if (typeof e === 'string') {
            return alert(e);
          } else {
            return alert(e.message);
          }
        });
      } else {
        return alert('位置情報を取得できません。');
      }
    };
    $scope.searchShops = function() {
      var obj;
      obj = {
        placeAddress: $scope.input.address,
        shopDistance: targetDistance
      };
      return setMapData(obj);
    };
    setMapData = function(obj) {
      return Api.getJson(obj, Const.API.SHOP + "/api.json").then(function(resShops) {
        var shops;
        $scope.map.center.latitude = resShops.data.current.latitude;
        $scope.map.center.longitude = resShops.data.current.longitude;
        $scope.input.address = resShops.data.current.address;
        shops = [];
        angular.forEach(resShops.data.shops, function(shop, i) {
          var ret;
          ret = {
            latitude: shop.latitude,
            longitude: shop.longitude,
            showWindow: true,
            title: shop.name,
            url: shop.image.thumb.url
          };
          ret['id'] = shop.id;
          return shops.push(ret);
        });
        return $scope.targetMarkers = shops;
      });
    };
    return $scope.clickMarker = function($event) {};
  });

}).call(this);

//# sourceMappingURL=map.js.map
