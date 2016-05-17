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

    ###
    # setting
    ###
    $scope.targetId = $stateParams.id
    $rootScope.isHideTab = true

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
        appKeywords = []
        angular.forEach $scope.shops, (shop) ->
          appKeywords.push(shop.shop.name)
        $rootScope.appTitle = $scope.post.title
        $rootScope.appDescription = $scope.post.content.substr(0, 150)
        $rootScope.appImage = $scope.post.image.url
        $rootScope.appKeywords = appKeywords.join()

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
      else if $state.is('tabs.shop.map') || $state.is('tabs.map-post')
        $scope.nowTab = 'map'
      else if $state.is('tabs.shop.post-detail')
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
        $state.go('tabs.map-post', { id: id })
      else if $scope.nowTab == 'shop'
        $state.go('tabs.shop.post-detail', { id: id })
      else
        $state.go('post', { id: $scope.user.id })

    $scope.moveToShopDetail = (id) ->
      if $scope.nowTab == 'magazine'
        $state.go('tabs.post-shop', { id: id })
      else if $scope.nowTab == 'map'
        $state.go('tabs.map-shop', { id: id })
      else if $scope.nowTab == 'shop'
        $state.go('tabs.shop.detail', { id: id })
      else
        $state.go('tabs.shopDetal', { id: id })

    $scope.moveToWriterDetail = ->
      if $scope.nowTab == 'magazine'
        $state.go('tabs.post-writer', { id: $scope.user.id })
      else if $scope.nowTab == 'map'
        $state.go('tabs.map-writer', { id: $scope.user.id })
      else if $scope.nowTab == 'shop'
        $state.go('tabs.shop.writer-detail', { id: $scope.user.id })
      else
        $state.go('writer', { id: $scope.user.id })
