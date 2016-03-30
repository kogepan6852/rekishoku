'use strict'

###*
 # @ngdoc function
 # @name frontApp.controller:PostDetailCtrl
 # @description
 # # PostDetailCtrl
 # Controller of the frontApp
###
angular.module 'frontApp'
  .controller "PostDetailCtrl", ($scope, $rootScope, $stateParams, $ionicHistory, $controller, $state, $location, Api, Const, config, BaseService) ->

    # Controllerの継承
    $controller 'BaseCtrl', $scope: $scope

    # 変数設定
    $scope.targetId = $stateParams.id
    $rootScope.isHideTab = true
    $scope.urlFb = config.url.home + $location.url()
    $scope.urlTwitter = config.url.home + $location.url()

    # 初期処理
    FB.init
      appId: config.id.fb
      status: true
      cookie: true

    # 投稿内容取得
    path = Const.API.POST + '/' + $stateParams.id
    if $stateParams.preview
      path += '?preview=' + $stateParams.preview
    Api.getJson("", path, true).then (res) ->
      $scope.post = res.data.post
      $scope.shops = res.data.shops
      $scope.user = res.data.user
      $scope.people = res.data.people
      $scope.eyeCatchImage = res.data.eye_catch_image

      # SEO
      appKeywords = []
      angular.forEach $scope.shops, (shop) ->
        appKeywords.push(shop.shop.name)
      $rootScope.appTitle = $scope.post.title
      $rootScope.appDescription = $scope.post.content.substr(0, 150)
      $rootScope.appImage = $scope.post.image.url
      $rootScope.appKeywords = appKeywords.join()

      # 関連投稿内容取得
      pathRelated = Const.API.POSTS_RELATED + '/' + $stateParams.id
      # if $scope.people.length == 0
      #   pathRelated += '?type=1'
      Api.getJson("", pathRelated, true).then (res) ->
        num = 5
        if res.data.length < num
          num = res.data.length
        $scope.postsRelated = BaseService.getRandomArray(res.data, num)

    Api.getJson("", Const.API.POST_DETSIL + '/' + $stateParams.id, true).then (res) ->
      $scope.postDetails = res.data


    # 現在タブの判定
    if $state.is('tabs.post')
      $scope.nowTab = 'post'
    else if $state.is('tabs.map') || $state.is('tabs.map-post')
      $scope.nowTab = 'map'
    else if $state.is('tabs.shop') || $state.is('tabs.shop-post')
      $scope.nowTab = 'shop'
    else
      $scope.nowTab = 'other'

    # Function
    $scope.myGoBack = ->
      $ionicHistory.goBack()

    $scope.postToFeed = ->
      obj =
        display: 'popup'
        method: 'share'
        href: $scope.urlFb
        picture: $scope.eyeCatchImage.image.url
        title: $scope.post.title
        caption: '歴食.jp'
        description: $scope.post.content
      FB.ui obj

    $scope.moveToWriterDetail = ->
      if $scope.nowTab == 'post'
        $state.go('tabs.post-writer', { id: $scope.user.id })
      else if $scope.nowTab == 'map'
        $state.go('tabs.map-writer', { id: $scope.user.id })
      else if $scope.nowTab == 'shop'
        $state.go('tabs.shop-writer', { id: $scope.user.id })
      else
        $state.go('writer', { id: $scope.user.id })
