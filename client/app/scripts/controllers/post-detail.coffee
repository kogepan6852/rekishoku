'use strict'

###*
 # @ngdoc function
 # @name frontApp.controller:PostDetailCtrl
 # @description
 # # PostDetailCtrl
 # Controller of the frontApp
###
angular.module 'frontApp'
  .controller "PostDetailCtrl", ($scope, $rootScope, $stateParams, $ionicHistory, $controller, $state, $location, Api, Const, config, BaseService, $translate, $window) ->

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
      if $scope.post && $scope.people && $scope.eyeCatchImage
        setSeo()

    ###
    # common function
    ###
    setSeo = ->
      appKeywords = []
      appKeywords.push($translate.instant('SEO.KEYWORDS.MEAL'))
      angular.forEach $scope.people, (person) ->
        appKeywords.push(person.name)
      if $scope.post.category_slug =="cooking"
        appKeywords = []
        appKeywords.push($translate.instant('SEO.KEYWORDS.BASE'))
        appKeywords.push($translate.instant('SEO.KEYWORDS.COOKING'))
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
      Api.getJson("", path, true).then (res) ->
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
        Api.getJson("", pathRelated, true).then (res) ->
          num = 5
          if res.data.length < num
            num = res.data.length
          $scope.postsRelated = BaseService.getRandomArray(res.data, num)

      # 投稿内容詳細取得
      Api.getJson("", Const.API.POST_DETSIL + '/' + $stateParams.id, true).then (res) ->
        $scope.postDetails = res.data

      # 現在タブの判定
      if $state.is('tabs.postDetal')
        $scope.nowTab = 'magazine'
      else if $state.is('tabs.shop.postDetailMap')
        $scope.nowTab = 'map'
      else if $state.is('tabs.shop.postDetail')
        $scope.nowTab = 'shop'
      else
        $scope.nowTab = 'other'

    ###
    # function
    ###
    $scope.moveToPostDetail = (id) ->
      if $scope.nowTab == 'magazine'
        $state.go('tabs.postDetal', { id: id })
      else if $scope.nowTab == 'map'
        $state.go('tabs.shop.postDetailMap', { id: id })
      else if $scope.nowTab == 'shop'
        $state.go('tabs.shop.postDetail', { id: id })
      else
        $state.go('post', { id: $scope.user.id })

    $scope.moveToShopDetail = (id) ->
      if $scope.nowTab == 'magazine'
        $state.go('tabs.shopDetailPost', { id: id })
      else if $scope.nowTab == 'map'
        $state.go('tabs.shop.detailMap', { id: id })
      else if $scope.nowTab == 'shop'
        $state.go('tabs.shop.shopDetail', { id: id })
      else
        $state.go('shop', { id: id })

    $scope.moveToWriterDetail = ->
      if $scope.nowTab == 'magazine'
        $state.go('tabs.writerPost', { id: $scope.user.id })
      else if $scope.nowTab == 'map'
        $state.go('tabs.shop.mapWriter', { id: $scope.user.id })
      else if $scope.nowTab == 'shop'
        $state.go('tabs.shop.writerDetail', { id: $scope.user.id })
      else
        $state.go('writer', { id: $scope.user.id })
