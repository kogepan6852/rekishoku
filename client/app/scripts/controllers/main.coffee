'use strict'

###*
 # @ngdoc function
 # @name frontApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the frontApp
###
angular.module "frontApp"
  .controller "MainCtrl", ($scope, $rootScope, $ionicSideMenuDelegate, $location, $controller, $ionicNavBarDelegate, $localStorage, Api, Const) ->

    # Controllerの継承
    $controller 'BaseCtrl', $scope: $scope

    # setting
    $rootScope.appTitle = "歴食 | 記事を見る"
    $scope.targetCategoryId = null
    $rootScope.isHideTab = false
    $ionicNavBarDelegate.showBackButton false

    categoryObj =
      type: "PostCategory"
    Api.getJson(categoryObj, Const.API.CATEGORY, true).then (res) ->
      $scope.categories = res.data

    # initialize
    $scope.init = ->
      $scope.noMoreLoad = false
      $scope.page = 1
      obj =
        email: $localStorage['email']
        token: $localStorage['token']
        per: Const.API.SETTING.PER
        page: 1
      if $scope.targetCategoryId
        obj.category = $scope.targetCategoryId
      # 検索ワードの設定
      $scope.keywords = $location.search()['keywords']
      if $scope.keywords
        obj.keywords = $scope.keywords

      Api.getJson(obj, Const.API.POST, true).then (res) ->
        $scope.posts = res.data
        $scope.$broadcast 'scroll.refreshComplete'
        $scope.$broadcast('scroll.infiniteScrollComplete')

    $rootScope.postsSearch = (categoryId) ->
      $scope.targetCategoryId = null
      $scope.search(categoryId)

    # Function
    # 検索処理
    $scope.search = (categoryId) ->
      $scope.page = 1
      obj =
        per: Const.API.SETTING.PER
        page: $scope.page
      if categoryId == $scope.targetCategoryId
        # 検索条件解除
        $scope.targetCategoryId = null
      else
        # 検索条件設定
        $scope.targetCategoryId = categoryId
        obj.category = categoryId

      # 検索ワードの設定
      $scope.keywords = $location.search()['keywords']
      if $scope.keywords
        obj.keywords = $scope.keywords

      # 検索
      Api.getJson(obj, Const.API.POST, true).then (res) ->
        $scope.posts = res.data
        if res.data.length == 0
          $scope.noMoreLoad = true
        $scope.$broadcast('scroll.infiniteScrollComplete')

    # ListのLazy Load用処理
    $scope.loadMoreData = ->
      if $scope.posts
        $scope.page += 1
        obj =
          per: Const.API.SETTING.PER
          page: $scope.page
          category: $scope.targetCategoryId
        # 検索ワードの設定
        if $scope.keywords
          obj.keywords = $scope.keywords

        Api.getJson(obj, Const.API.POST, true).then (res) ->
          if res.data.length == 0
            $scope.noMoreLoad = true
          else
            angular.forEach res.data, (data, i) ->
              $scope.posts.push(data)
          $scope.$broadcast('scroll.infiniteScrollComplete')

    # 検索条件削除
    $scope.deleteSearchCondition = ->
      $scope.targetCategoryId = null
      $scope.keywords = null
      $location.search('keywords', null)
      $scope.search()

    # postのmouse over時の挙動
    $scope.onMouseOverItem = (post) ->
      post.onMouse = true

    # postのmouse leave時の挙動
    $scope.onMousemouseLeave = (post) ->
      post.onMouse = false
