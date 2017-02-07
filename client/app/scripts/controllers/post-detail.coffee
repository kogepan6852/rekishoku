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

    # Map用パラメータの設定
    $scope.map =
      center:
        latitude: Const.MAP.CENTER.DEFAULT.LAT
        longitude:  Const.MAP.CENTER.DEFAULT.LNG
      zoom: Const.MAP.ZOOM.DEFAULT
      bounds: {}
    $scope.options =
      gestureHandling: 'cooperative'
      minZoom: Const.MAP.ZOOM.MIN
      zoomControl: true
      fullscreenControl: true
      disableDefaultUI: true

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
      $rootScope.appImage = $scope.eyeCatchImage.md.url
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

        # Map用
        shops = []
        latArray = []
        lngArray = []

        # Map用アイコンの設定
        angular.forEach $scope.postDetails, (postDetail, i) ->
          if postDetail.shop
            target = postDetail.shop
            idType = "shop"
          else if postDetail.external_link
            target = postDetail.external_link
            idType = "link"

          if target
            ret =
              latitude: target.latitude
              longitude: target.longitude
              showWindow: true
              title: target.name
              url: target.image.thumb.url
              icon:
                url: '../images/map-pin' + (i + 1) + '.png'
                scaledSize : new google.maps.Size(25, 35)
            ret['id'] = i
            shops.push(ret)
            latArray.push(target.latitude)
            lngArray.push(target.longitude)
        $scope.targetMarkers = shops

        # shopが全て収まるzoomを計算
        maxLat = Math.max.apply(null, latArray)
        minLat = Math.min.apply(null, latArray)
        maxlng = Math.max.apply(null, lngArray)
        minLng = Math.min.apply(null, lngArray)
        latDistance = maxLat - minLat
        lngDistance = maxlng - minLng
        targetZoom = BaseService.getZoomByDistance(latDistance, lngDistance)

        # Map用パラメータの設定
        $scope.map.center.latitude = (maxLat + minLat) / 2
        $scope.map.center.longitude = (maxlng + minLng) / 2
        $scope.map.zoom = targetZoom

      DataService.getPeriod (data) ->
        $scope.allPeriods = data

    ###
    # function
    ###
    $scope.isFeature = (post) ->
      isFeature = false
      if post && (post.category_slug == 'tour' || post.category_slug == 'event')
        isFeature = true
      return isFeature

    $scope.clickExternalLink = (detail) ->
      detail.showLink = !detail.showLink
