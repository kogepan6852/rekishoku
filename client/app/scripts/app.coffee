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

      # STORE LIST
      .state 'tabs.shop.list',
        url: '/app/shop/list'
        views:
          'tab-shop-list':
            templateUrl: 'views/shops.html'
            controller: 'ShopsCtrl'

      # STORE MAP
      .state 'tabs.shop.map',
        url: '/app/shop/map'
        views:
          'tab-shop-map':
            templateUrl: 'views/map.html'
            controller: 'MapCtrl'

      # POST DETAILS
      .state 'tabs.postDetal',
        url: '/app/post/:id'
        views:
          'tab-magazine':
            templateUrl: 'views/post-detail.html'
            controller: 'PostDetailCtrl'

      # STORE DETAIL DIRECT
      .state 'tabs.shopDetal',
        url: '/app/shop/:id'
        views:
          'tab-shop':
            templateUrl: 'views/shop-detail.html'
            controller: 'ShopDetailCtrl'

      # STORE DETAILS
      .state 'tabs.shop.detail',
        url: '/app/shop/:id'
        views:
          'tab-shop-list':
            templateUrl: 'views/shop-detail.html'
            controller: 'ShopDetailCtrl'


      # MAGAZINEタブ用の各ページのルーティング
      # .state 'tabs.post.detail',
      #   cache: false,
      #   url: '/app/post/:id?preview'
      #   views:
      #     'tab-magazine':
      #       templateUrl: 'views/post-detail.html'
      #       controller: 'PostDetailCtrl'
      .state 'tabs.post-shop',
        cache: false,
        url: '/app/shop/:id'
        views:
          'tab-magazine':
            templateUrl: 'views/shop-detail.html'
            controller: 'ShopDetailCtrl'
      .state 'tabs.post-writer',
        cache: false,
        url: '/app/writer/:id'
        views:
          'tab-magazine':
            templateUrl: 'views/writer-detail.html'
            controller: 'WriterDetailCtrl'


      # STORE LISTタブ用の各ページのルーティング
      .state 'tabs.shop.post-detail',
        cache: false,
        url: '/app/post/:id'
        views:
          'tab-shop-list':
            templateUrl: 'views/post-detail.html'
            controller: 'PostDetailCtrl'
      .state 'tabs.shop.writer-detail',
        cache: false,
        url: '/app/writer/:id'
        views:
          'tab-shop-list':
            templateUrl: 'views/writer-detail.html'
            controller: 'WriterDetailCtrl'




      .state 'tabs.map',
        url: '/app/map'
        views:
          'map-tab':
            templateUrl: 'views/map.html'
            controller: 'MapCtrl'
      .state 'tabs.map-post',
        cache: false,
        url: '/app/post/:id'
        views:
          'map-tab':
            templateUrl: 'views/post-detail.html'
            controller: 'PostDetailCtrl'
      .state 'tabs.map-shop',
        cache: false,
        url: '/app/shop/:id'
        views:
          'map-tab':
            templateUrl: 'views/shop-detail.html'
            controller: 'ShopDetailCtrl'
      .state 'tabs.map-shop2',
        cache: false,
        url: '/app/map-shop/:id'
        views:
          'map-tab':
            templateUrl: 'views/shop-detail.html'
            controller: 'ShopDetailCtrl'
      .state 'tabs.map-writer',
        cache: false,
        url: '/app/writer/:id'
        views:
          'map-tab':
            templateUrl: 'views/writer-detail.html'
            controller: 'WriterDetailCtrl'

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
      .state 'shop',
        url: '/app/shop/:id'
        templateUrl: 'views/shop-detail.html'
        controller: 'ShopDetailCtrl'

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
    # $locationProvider.html5Mode(true);
