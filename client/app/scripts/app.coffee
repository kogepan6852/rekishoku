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
    'config',
    'pascalprecht.translate',
    'angulartics',
    'angulartics.google.analytics'
  ]
  .config ($stateProvider, $urlRouterProvider) ->
    $stateProvider
      .state 'tabs',
        abstract: true,
        templateUrl: "views/tabs.html"

      # MAGAZINE TAB
      .state 'tabs.magazine',
        url: '/app/magazine'
        views:
          'tab-magazine':
            templateUrl: 'views/magazine.html'
            controller: 'MagazineCtrl'

      # STORE TAB
      .state 'tabs.shop',
        abstract: true
        views:
          'tab-shop':
            templateUrl: 'views/tab-shop.html'

      # STORE TAB LIST
      .state 'tabs.shop.list',
        url: '/app/shop/list'
        views:
          'tab-shop-list':
            templateUrl: 'views/shops.html'
            controller: 'ShopsCtrl'

      # STORE TAB MAP
      .state 'tabs.shop.map',
        cache: false
        url: '/app/shop/map'
        views:
          'tab-shop-map':
            templateUrl: 'views/map.html'
            controller: 'MapCtrl'

      # MAGAZINEタブ用の各ページのルーティング
      .state 'tabs.postDetal',
        cache: false
        url: '/app/post/:id'
        views:
          'tab-magazine':
            templateUrl: 'views/post-detail.html'
            controller: 'PostDetailCtrl'
      .state 'tabs.writerPost',
        cache: false,
        url: '/app/writer/:id'
        views:
          'tab-magazine':
            templateUrl: 'views/writer-detail.html'
            controller: 'WriterDetailCtrl'
      .state 'tabs.shopDetalPost',
        cache: false
        url: '/app/shop/:id'
        views:
          'tab-magazine':
            templateUrl: 'views/shop-detail.html'
            controller: 'ShopDetailCtrl'

      # STORE DETAIL DIRECT
      .state 'tabs.shopDetal',
        cache: false
        url: '/app/shop/:id'
        views:
          'tab-shop':
            templateUrl: 'views/shop-detail.html'
            controller: 'ShopDetailCtrl'

      # STORE LISTタブ用の各ページのルーティング
      .state 'tabs.shop.shopDetail',
        cache: false
        url: '/app/shop/:id'
        views:
          'tab-shop-list':
            templateUrl: 'views/shop-detail.html'
            controller: 'ShopDetailCtrl'
      .state 'tabs.shop.postDetail',
        cache: false,
        url: '/app/post/:id'
        views:
          'tab-shop-list':
            templateUrl: 'views/post-detail.html'
            controller: 'PostDetailCtrl'
      .state 'tabs.shop.writerDetail',
        cache: false,
        url: '/app/writer/:id'
        views:
          'tab-shop-list':
            templateUrl: 'views/writer-detail.html'
            controller: 'WriterDetailCtrl'

      # STORE DETAILS
      .state 'tabs.shop.detailMap',
        cache: false
        url: '/app/map-shop/:id'
        views:
          'tab-shop-map':
            templateUrl: 'views/shop-detail.html'
            controller: 'ShopDetailCtrl'

      # STORE MAPタブ用の各ページのルーティング
      .state 'tabs.shop.postDetailMap',
        cache: false,
        url: '/app/post/:id'
        views:
          'tab-shop-map':
            templateUrl: 'views/post-detail.html'
            controller: 'PostDetailCtrl'
      .state 'tabs.shop.mapWriter',
        cache: false,
        url: '/app/writer/:id'
        views:
          'tab-shop-map':
            templateUrl: 'views/writer-detail.html'
            controller: 'WriterDetailCtrl'

      # そのた
      .state 'my-post',
        cache: false,
        url: '/app/my-post'
        templateUrl: 'views/post-list.html'
        controller: 'PostListCtrl'
      .state 'writers',
        url: '/app/writers'
        templateUrl: 'views/writers.html'
        controller: 'WritersCtrl'
      .state 'writer',
        cache: false,
        url: '/app/writer/:id'
        templateUrl: 'views/writer-detail.html'
        controller: 'WriterDetailCtrl'

      .state 'post',
        cache: false,
        url: '/app/post/:id?preview'
        templateUrl: 'views/post-detail.html'
        controller: 'PostDetailCtrl'

      # 旧URL用の暫定パス
      .state 'post-old',
        cache: false,
        url: '/post/:id?preview'
        templateUrl: 'views/post-detail.html'
        controller: 'PostDetailCtrl'


    $urlRouterProvider.otherwise ('/app/magazine')

  .config(["$httpProvider", ($httpProvider) ->

    $httpProvider.defaults.transformRequest = (data) ->
      return data if data is `undefined`
      $.param data

    $httpProvider.defaults.headers.post = "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
  ])
  # angular-translateの設定
  .config(["$translateProvider", ($translateProvider) ->
    $translateProvider.useStaticFilesLoader
      prefix: 'assets/i18n/locale-'
      suffix: '.json'
    $translateProvider.preferredLanguage 'ja'
    $translateProvider.fallbackLanguage 'ja'
  ])

  .config ($ionicConfigProvider) ->
    $ionicConfigProvider.views.maxCache(5)
    $ionicConfigProvider.views.transition('ios')
    $ionicConfigProvider.views.forwardCache(true);
    $ionicConfigProvider.tabs.position('top');
    $ionicConfigProvider.backButton.previousTitleText(false).text('');

  .config ($locationProvider) ->
    # $locationProvider.hashPrefix('!')
    $locationProvider.html5Mode(true);
