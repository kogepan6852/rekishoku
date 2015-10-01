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
    'toaster'
  ]
  .config ($stateProvider, $urlRouterProvider) ->
    $stateProvider
      .state 'tabs',
        url: "/tab",
        abstract: true,
        templateUrl: "views/tabs.html"
      .state 'tabs.home',
        url: '/home'
        views:
          'home-tab':
            templateUrl: 'views/main.html'
            controller: 'MainCtrl'
      .state 'tabs.map',
        url: '/map'
        views:
          'map-tab':
            templateUrl: 'views/map.html'
            controller: 'MapCtrl'
      .state 'tabs.list',
        url: '/list'
        views:
          'list-tab':
            templateUrl: 'views/post-list.html'
            controller: 'PostListCtrl'
    $urlRouterProvider.otherwise ('/tab/home')

  .config(["$httpProvider", ($httpProvider) ->

    $httpProvider.defaults.transformRequest = (data) ->
      return data if data is `undefined`
      $.param data

    $httpProvider.defaults.headers.post = "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
  ])
  .config ($ionicConfigProvider) ->
    $ionicConfigProvider.views.transition('none')
