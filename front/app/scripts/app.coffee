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
    'uiGmapgoogle-maps'
  ]
  .config ($stateProvider, $urlRouterProvider) ->
    $stateProvider
      .state 'home',
        url: "/home",
        templateUrl: "views/tabs.html"
      .state 'post',
        cache: false,
        url: '/post/:id'
        templateUrl: 'views/post-detail.html'
        controller: 'PostDetailCtrl'
      .state 'shop',
        cache: false,
        url: '/shop/:id'
        templateUrl: 'views/shop-detail.html'
        controller: 'ShopDetailCtrl'
      .state 'my-post',
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
