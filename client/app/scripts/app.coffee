'use strict'

###*
 # @ngdoc overview
 # @name frontApp
 # @description
 # # frontApp
 #
 # Main module of the application.
###
angular
  .module 'frontApp', [
    'ngAnimate',
    'ngCookies',
    'ngResource',
    'ngRoute',
    'ngSanitize',
    'ngTouch',
    'ionic',
    'ui.router',
    'ngStorage',
    'toaster',
    'uiGmapgoogle-maps',
    'config'
  ]
  .config ($stateProvider, $urlRouterProvider) ->
    $stateProvider
      .state 'tabs',
        url: "",
        abstract: true,
        templateUrl: "views/tabs.html"
      .state 'tabs.home',
        url: '/home'
        views:
          'home-tab':
            templateUrl: 'views/main.html'
            controller: 'MainCtrl'
      .state 'tabs.shops',
        url: '/shops'
        views:
          'shops-tab':
            templateUrl: 'views/shops.html'
            controller: 'ShopsCtrl'

      .state 'tabs.post',
        cache: false,
        url: '/post/:id'
        views:
          'home-tab':
            templateUrl: 'views/post-detail.html'
            controller: 'PostDetailCtrl'
      .state 'tabs.post-shop',
        cache: false,
        url: '/shop/:id'
        views:
          'home-tab':
            templateUrl: 'views/shop-detail.html'
            controller: 'ShopDetailCtrl'
      .state 'tabs.shop',
        cache: false,
        url: '/shop/:id'
        views:
          'shops-tab':
            templateUrl: 'views/shop-detail.html'
            controller: 'ShopDetailCtrl'
      .state 'tabs.shop-post',
        cache: false,
        url: '/post/:id'
        views:
          'shops-tab':
            templateUrl: 'views/post-detail.html'
            controller: 'PostDetailCtrl'

      .state 'tabs.map',
        url: '/map'
        views:
          'map-tab':
            templateUrl: 'views/map.html'
            controller: 'MapCtrl'
      .state 'tabs.map-post',
        cache: false,
        url: '/post/:id'
        views:
          'map-tab':
            templateUrl: 'views/post-detail.html'
            controller: 'PostDetailCtrl'
      .state 'tabs.map-shop',
        cache: false,
        url: '/shop/:id'
        views:
          'map-tab':
            templateUrl: 'views/shop-detail.html'
            controller: 'ShopDetailCtrl'
      .state 'tabs.map-shop2',
        cache: false,
        url: '/map-shop/:id'
        views:
          'map-tab':
            templateUrl: 'views/shop-detail.html'
            controller: 'ShopDetailCtrl'


      .state 'my-post',
        cache: false,
        url: '/my-post'
        templateUrl: 'views/post-list.html'
        controller: 'PostListCtrl'
      .state 'writers',
        url: '/writers'
        templateUrl: 'views/writers.html'
        controller: 'WritersCtrl'
      .state 'writer',
        cache: false,
        url: '/writer/:id'
        templateUrl: 'views/writer-detail.html'
        controller: 'WriterDetailCtrl'

      .state 'post',
        cache: false,
        url: '/post/:id'
        templateUrl: 'views/post-detail.html'
        controller: 'PostDetailCtrl'
      .state 'shop',
        url: '/shop/:id'
        templateUrl: 'views/shop-detail.html'
        controller: 'ShopDetailCtrl'


    $urlRouterProvider.otherwise ('/home')

  .config(["$httpProvider", ($httpProvider) ->

    $httpProvider.defaults.transformRequest = (data) ->
      return data if data is `undefined`
      $.param data

    $httpProvider.defaults.headers.post = "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
  ])
  .config ($ionicConfigProvider) ->
    $ionicConfigProvider.views.maxCache(5)
    $ionicConfigProvider.views.transition('ios')
    $ionicConfigProvider.views.forwardCache(true);
