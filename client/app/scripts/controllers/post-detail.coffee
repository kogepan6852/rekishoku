'use strict'

###*
 # @ngdoc function
 # @name frontApp.controller:PostDetailCtrl
 # @description
 # # PostDetailCtrl
 # Controller of the frontApp
###
angular.module 'frontApp'
  .controller "PostDetailCtrl", ($scope, $rootScope, $stateParams, $ionicHistory, $controller, $state, $location, Api, Const, config, BaseService, $translate, $window, DataService, $ionicNavBarDelegate, $ionicScrollDelegate) ->

    # Controllerの継承
    $controller 'BaseCtrl', $scope: $scope

    ###
    # setting
    ###
    $scope.targetId = $stateParams.id
    $rootScope.isHideTab = true

    # 画面表示ごとの初期処理
    $scope.$on '$ionicView.beforeEnter', (e) ->
      $window.prerenderReady = false;
      $ionicNavBarDelegate.showBackButton true
      if $scope.post && $scope.people && $scope.eyeCatchImage
        setSeo()

    ###
    # common function
    ###
    setSeo = ->
      appKeywords = []
      # 人物
      angular.forEach $scope.people, (person) ->
        appKeywords.push(person.name)
      # 時代
      angular.forEach $scope.periods, (period) ->
        appKeywords.push(period.name)
      # 固定ワード
      appKeywords.push($translate.instant('SEO.KEYWORDS.COOKING'))
      appKeywords.push($translate.instant('SEO.KEYWORDS.KINSHIP'))
      # 歴食クッキング
      if $scope.post.category_slug =="cooking"
        appKeywords = []
        appKeywords.push($translate.instant('SEO.KEYWORDS.R_COOKING'))
      # セット
      $rootScope.appTitle = $translate.instant('SEO.TITLE.BASE') + $scope.post.title
      $rootScope.appDescription = $scope.post.content.substr(0, 150)
      $rootScope.appImage = $scope.eyeCatchImage.image.md.url
      $rootScope.appKeywords = appKeywords.join()

      # Prerender.io
      $scope.readyToCache(1000)

    ###
    # initialize
    ###
    $scope.init = ->
      # 投稿内容取得
      path = Const.API.POST + '/' + $stateParams.id
      if $stateParams.preview
        path += '?preview=' + $stateParams.preview
      Api.getJson("", path, false).then (res) ->
        $scope.post = res.data.post
        $scope.shops = res.data.shops
        $scope.user = res.data.user
        $scope.people = res.data.people
        $scope.periods = res.data.periods
        $scope.eyeCatchImage = res.data.eye_catch_image

        # SEO
        setSeo()

        # 関連投稿内容取得
        pathRelated = Const.API.POSTS_RELATED + '/' + $stateParams.id
        if $scope.people.length == 0
          pathRelated += '?type=1'
        Api.getJson("", pathRelated, false).then (res) ->
          num = 5
          if res.data.length < num
            num = res.data.length
          $scope.postsRelated = BaseService.getRandomArray(res.data, num)
          $ionicScrollDelegate.$getByHandle('postDetailScroll').resize()

      # 投稿内容詳細取得
      Api.getJson("", Const.API.POST_DETSIL + '/' + $stateParams.id, false).then (res) ->
        $scope.postDetails = res.data
        $ionicScrollDelegate.$getByHandle('postDetailScroll').resize()

      DataService.getPeriod (data) ->
        $scope.allPeriods = data

    ###
    # function
    ###
