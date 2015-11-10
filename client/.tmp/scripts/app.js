(function() {
  'use strict';

  /**
    * @ngdoc overview
    * @name frontApp
    * @description
    * # frontApp
    *
    * Main module of the application.
   */
  angular.module('frontApp', ['ngAnimate', 'ngCookies', 'ngResource', 'ngRoute', 'ngSanitize', 'ngTouch', 'ionic', 'ui.router', 'ngStorage', 'toaster', 'uiGmapgoogle-maps', 'config']).config(function($stateProvider, $urlRouterProvider) {
    $stateProvider.state('home', {
      url: "/home",
      templateUrl: "views/tabs.html"
    }).state('post', {
      cache: false,
      url: '/post/:id',
      templateUrl: 'views/post-detail.html',
      controller: 'PostDetailCtrl'
    }).state('shop', {
      cache: false,
      url: '/shop/:id',
      templateUrl: 'views/shop-detail.html',
      controller: 'ShopDetailCtrl'
    }).state('my-post', {
      cache: false,
      url: '/my-post',
      templateUrl: 'views/post-list.html',
      controller: 'PostListCtrl'
    }).state('writers', {
      url: '/writers',
      templateUrl: 'views/writers.html',
      controller: 'WritersCtrl'
    }).state('writer', {
      cache: false,
      url: '/writer/:id',
      templateUrl: 'views/writer-detail.html',
      controller: 'WriterDetailCtrl'
    });
    return $urlRouterProvider.otherwise('/home');
  }).config([
    "$httpProvider", function($httpProvider) {
      $httpProvider.defaults.transformRequest = function(data) {
        if (data === undefined) {
          return data;
        }
        return $.param(data);
      };
      return $httpProvider.defaults.headers.post = {
        "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
      };
    }
  ]).config(function($ionicConfigProvider) {
    $ionicConfigProvider.views.maxCache(5);
    $ionicConfigProvider.views.transition('ios');
    return $ionicConfigProvider.views.forwardCache(true);
  });

}).call(this);

//# sourceMappingURL=app.js.map
