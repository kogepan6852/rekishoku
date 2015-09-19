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
    'ngTouch'
  ]
  .config ($routeProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
        controllerAs: 'main'
      .when '/about',
        templateUrl: 'views/about.html'
        controller: 'AboutCtrl'
        controllerAs: 'about'
      .otherwise
        redirectTo: '/'
  .config(["$httpProvider", ($httpProvider) ->

    $httpProvider.defaults.transformRequest = (data) ->
      return data if data is `undefined`
      $.param data

    $httpProvider.defaults.headers.post = "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
  ])