'use strict'

###*
 # @ngdoc function
 # @name frontApp.controller:FeatureDetailCtrl
 # @description
 # FeatureDetailCtrl
 # Controller of the frontApp
###
angular.module 'frontApp'
  .controller "FeatureDetailCtrl", ($scope, $rootScope, $stateParams, $controller, $state, Api, Const, config, BaseService, $translate, $window) ->

    # Controllerの継承
    $controller 'BaseCtrl', $scope: $scope

    ###
    # setting
    ###
    $scope.targetId = $stateParams.id
    $rootScope.hideFooter = true
    $rootScope.hideModeBtn = true

    # Map用パラメータの設定
    $scope.map =
      center:
        latitude: Const.MAP.CENTER.DEFAULT.LAT
        longitude:  Const.MAP.CENTER.DEFAULT.LNG
      zoom: Const.MAP.ZOOM.DEFAULT
      bounds: {}
    $scope.options =
      scrollwheel: false
      minZoom: Const.MAP.ZOOM.MIN
      disableDefaultUI: true
      zoomControl: true
      draggable: false

    # 画面表示ごとの初期処理
    $scope.$on '$ionicView.beforeEnter', (e) ->
      $window.prerenderReady = false;
      if $scope.feature && $scope.featureDetails
        setSeo()

    ###
    # common function
    ###
    setSeo = ->
      appKeywords = []
      angular.forEach $scope.featureDetails, (featureDetail) ->
        if featureDetail.shop
          appKeywords.push(featureDetail.shop.name)
      $rootScope.appTitle = $translate.instant('SEO.TITLE.BASE') + $scope.feature.title
      $rootScope.appDescription = $scope.feature.content.substr(0, 150)
      $rootScope.appImage = $scope.feature.image.url
      $rootScope.appKeywords = appKeywords.join()

      # Prerender.io
      $scope.readyToCache(1000)

    ###
    # initialize
    ###
    $scope.init = ->
      Api.getJson("", Const.API.FEATURE + '/' + $stateParams.id + '.json', true).then (res) ->
        $scope.feature = res.data.feature
        $scope.featureDetails = res.data.feature_details
        $scope.user = res.data.user
        $scope.people = res.data.people
        $scope.periods = res.data.periods

        # Map用
        shops = []
        latArray = []
        lngArray = []

        # Map用アイコンの設定
        angular.forEach $scope.featureDetails, (featureDetail, i) ->
          if featureDetail.shop
            target = featureDetail.shop
            idType = "shop"
          else if featureDetail.external_link
            target = featureDetail.external_link
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

        # SEO
        setSeo()

        $scope.$broadcast 'scroll.refreshComplete'

      # 現在タブの判定
      if $state.is('tabs.featureDetalPost')
        $scope.nowTab = 'magazine'
      # else if $state.is('tabs.shop.detailMap')
      #   $scope.nowTab = 'map'
      # else if $state.is('tabs.shop.shopDetail')
      #   $scope.nowTab = 'shop'
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
        $state.go('post', { id: id })

    $scope.moveToShopDetail = (id) ->
      if $scope.nowTab == 'magazine'
        $state.go('tabs.shopDetailPost', { id: id })
      else if $scope.nowTab == 'map'
        $state.go('tabs.shop.postDetailMap', { id: id })
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

    $scope.clickExternalLink = (detail) ->
      if $scope.windowType == 'xs'
        detail.showLink = !detail.showLink
      else
        $window.open detail.external_link.quotation_url
        return true
