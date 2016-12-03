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
    'angular-google-adsense',
    'angulartics',
    'angulartics.google.analytics'
  ]
  .config ($stateProvider, $urlRouterProvider, $routeProvider) ->
    $stateProvider
      .state 'tabs',
        url: '',
        templateUrl: "views/tabs.html"

      # MAGAZINE TAB
      .state 'tabs.magazine',
        url: '/app/magazine'
        templateUrl: 'views/magazine.html'
        controller: 'MagazineCtrl'

      # STORE TAB LIST
      .state 'tabs.shops',
        url: '/app/shops'
        templateUrl: 'views/shops.html'
        controller: 'ShopsCtrl'

      # MAP
      .state 'tabs.map',
        url: '/app/map'
        templateUrl: 'views/map.html'
        controller: 'MapCtrl'

      # MAP
      .state 'tabs.features',
        url: '/app/features'
        templateUrl: 'views/features.html'
        controller: 'FeaturesCtrl'

      # 記事詳細
      .state 'postDetail',
        url: '/app/post/:id?preview'
        templateUrl: 'views/post-detail.html'
        controller: 'PostDetailCtrl'

      # 店舗詳細
      .state 'shopDetail',
        url: '/app/shop/:id'
        templateUrl: 'views/shop-detail.html'
        controller: 'ShopDetailCtrl'

      # 特集詳細
      .state 'featureDetal',
        url: '/app/feature/:id'
        templateUrl: 'views/feature-detail.html'
        controller: 'FeatureDetailCtrl'

      # 投稿一覧
      .state 'my-post',
        cache: false,
        url: '/app/my-post'
        templateUrl: 'views/post-list.html'
        controller: 'PostListCtrl'

      # ライター一覧
      .state 'writers',
        url: '/app/writers'
        templateUrl: 'views/writers.html'
        controller: 'WritersCtrl'

      # ライター詳細
      .state 'writerDetail',
        url: '/app/writer/:id'
        templateUrl: 'views/writer-detail.html'
        controller: 'WriterDetailCtrl'

      # 旧URL用の暫定パス
      .state 'post-old',
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
    $locationProvider.hashPrefix('!')
    # $locationProvider.html5Mode(true);
