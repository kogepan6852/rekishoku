'use strict'

###*
 # @ngdoc function
 # @name frontApp.controller:ShopDetailCtrl
 # @description
 # # PostDetailCtrl
 # Controller of the frontApp
###
angular.module 'frontApp'
  .controller "ShopDetailCtrl", ($scope, $rootScope, $stateParams, $controller, $state, Api, Const, config, $location, $translate, $window, $ionicNavBarDelegate, DataService, $ionicScrollDelegate) ->

    # Controllerの継承
    $controller 'BaseCtrl', $scope: $scope

    ###
    # setting
    ###
    $scope.targetId = $stateParams.id
    $rootScope.hideFooter = true

    # Map用パラメータの設定
    $scope.map =
      center:
        latitude: Const.MAP.CENTER.DEFAULT.LAT
        longitude:  Const.MAP.CENTER.DEFAULT.LNG
      zoom: 14
    $scope.options =
      gestureHandling: 'cooperative'
      minZoom: Const.MAP.ZOOM.MIN
      zoomControl: true
      fullscreenControl: true
      disableDefaultUI: true
    $scope.allAreas = ['東京都','京都府','神奈川県','島根県','静岡県','愛知県']

    # 画面表示ごとの初期処理
    $scope.$on '$ionicView.beforeEnter', (e) ->
      $window.prerenderReady = false;
      $ionicNavBarDelegate.showBackButton true
      if $scope.shop
        setSeo()

    ###
    # common function
    ###
    setSeo = ->
      appKeywords = []
      # 店舗情報
      appKeywords.push($scope.shop.name)
      appKeywords.push($scope.shop.province)
      appKeywords.push($scope.shop.city)
      # 人物
      angular.forEach $scope.people, (person) ->
        appKeywords.push(person.name)
      # 時代
      angular.forEach $scope.periods, (period) ->
        appKeywords.push(period.name)
      # 代表料理
      menus = $scope.shop.menu.split('\r\n')
      angular.forEach menus, (menu) ->
        appKeywords.push(menu)
      # 固定ワード
      appKeywords.push($translate.instant('SEO.KEYWORDS.COOKING'))
      appKeywords.push($translate.instant('SEO.KEYWORDS.OLD_FIRM'))
      # セット
      $rootScope.appTitle = $translate.instant('SEO.TITLE.BASE') + $scope.shop.name
      $rootScope.appDescription = $scope.shop.description.substr(0, 150)
      $rootScope.appImage = $scope.shop.subimage.md.url
      $rootScope.appKeywords = appKeywords.join()

      # Prerender.io
      $scope.readyToCache(1000)

    ###
    # initialize
    ###
    $scope.init = ->
      Api.getJson("", Const.API.SHOP + '/' + $stateParams.id, false).then (res) ->
        $scope.shop = res.data.shop
        $scope.categories = res.data.categories
        $scope.posts = res.data.posts
        $scope.people = res.data.people
        $scope.periods = res.data.periods
        $scope.rating = res.data.rating
        $scope.price = res.data.price
        $scope.eyeCatchImage = res.data.shop.subimage.md.url

        # Map用
        $scope.map.center.latitude =  res.data.shop.latitude
        $scope.map.center.longitude = res.data.shop.longitude

        shops = []
        ret =
          latitude: res.data.shop.latitude
          longitude: res.data.shop.longitude
          showWindow: true
          title: res.data.shop.name
          url: res.data.shop.image.thumb.url
          icon:
            url: '../images/map-pin.png'
            scaledSize : new google.maps.Size(25, 35)
        ret['id'] = res.data.shop.id
        shops.push(ret)
        $scope.targetMarkers = shops

        # SEO
        setSeo()

        $scope.$broadcast 'scroll.refreshComplete'
        $ionicScrollDelegate.$getByHandle('shopDetailScroll').resize()

      DataService.getPeriod (data) ->
        $scope.allPeriods = data

      DataService.getPeople (data) ->
        allPeople = data
        allPeople.sort (a, b) ->
          if a.rating > b.rating
            return -1
          if a.rating < b.rating
            return 1
          return 0

        $scope.allPeople = allPeople.slice(0, 40)

    ###
    # function
    ###
