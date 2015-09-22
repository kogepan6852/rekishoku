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
    'ui.router'
  ]
  .config ($stateProvider, $urlRouterProvider) ->
    $stateProvider
      .state 'home',
        url: '/home'
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
      .state 'about',
        url: '/about'
        templateUrl: 'views/about.html'
        controller: 'AboutCtrl'
      .state 'list',
        url: '/list'
        templateUrl: 'views/post-list.html'
        controller: 'PostListCtrl'
      .state 'post',
        url: '/post'
        templateUrl: 'views/post.html'
        controller: 'PostCtrl'
    $urlRouterProvider.otherwise ('/home')

  .config(["$httpProvider", ($httpProvider) ->

    $httpProvider.defaults.transformRequest = (data) ->
      return data if data is `undefined`
      $.param data

    $httpProvider.defaults.headers.post = "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
  ])
  .config ($ionicConfigProvider) ->
    $ionicConfigProvider.views.transition('none')
