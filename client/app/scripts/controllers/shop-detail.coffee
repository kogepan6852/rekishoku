'use strict'

###*
 # @ngdoc function
 # @name frontApp.controller:ShopDetailCtrl
 # @description
 # # PostDetailCtrl
 # Controller of the frontApp
###
angular.module 'frontApp'
  .controller "ShopDetailCtrl", ($scope, $rootScope, $stateParams, $controller, $state, Api, Const, config, $location) ->

    # Controllerの継承
    $controller 'BaseCtrl', $scope: $scope

    ###
    # setting
    ###
    $scope.targetId = $stateParams.id
    $rootScope.isHideTab = true
    $scope.urlFb = config.url.home + $location.url()
    $scope.urlTwitter = config.url.home + $location.url()
    FB.init
      appId: config.id.fb
      status: true
      cookie: true

    ###
    # initialize
    ###
    $scope.init = ->
      Api.getJson("", Const.API.SHOP + '/' + $stateParams.id + '.json', true).then (res) ->
        $scope.shop = res.data.shop
        $scope.categories = res.data.categories
        $scope.posts = res.data.posts
        $scope.people = res.data.people
        $scope.periods = res.data.periods
        $scope.rating = res.data.rating
        $scope.price = res.data.price

        # Map用
        $scope.map =
          center:
            latitude: res.data.shop.latitude
            longitude: res.data.shop.longitude
          zoom: 14
          bounds: {}
        $scope.options =
          scrollwheel: false
          minZoom: 11
          disableDefaultUI: true
          zoomControl: true
          draggable: false

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
        appKeywords = []
        angular.forEach $scope.people, (person) ->
          appKeywords.push(person.name)
        $rootScope.appTitle = $scope.shop.name
        $rootScope.appDescription = $scope.shop.description.substr(0, 150)
        $rootScope.appImage = $scope.shop.subimage.url
        $rootScope.appKeywords = appKeywords.join()

        $scope.$broadcast 'scroll.refreshComplete'


      # 現在タブの判定
      if $state.is('tabs.post') || $state.is('tabs.post-shop')
        $scope.nowTab = 'post'
      else if $state.is('tabs.map') || $state.is('tabs.map-shop') || $state.is('tabs.map-shop2')
        $scope.nowTab = 'map'
      else if $state.is('tabs.shop')
        $scope.nowTab = 'shop'
      else
        $scope.nowTab = 'other'

    ###
    # function
    ###
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
