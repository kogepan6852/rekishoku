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
        $scope.eyeCatchImage = res.data.shop.subimage.md.url

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
      if $state.is('tabs.postDetal')
        $scope.nowTab = 'magazine'
      else if $state.is('tabs.shop.map') || $state.is('tabs.map-post')
        $scope.nowTab = 'map'
      else if $state.is('tabs.shop.detail') || $state.is('tabs.shop-post')
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
        $state.go('tabs.postDetal', { id: id })

    $scope.moveToShopDetail = (id) ->
      if $scope.nowTab == 'magazine'
        $state.go('tabs.post-shop', { id: id })
      else if $scope.nowTab == 'map'
        $state.go('tabs.map-shop', { id: id })
      else if $scope.nowTab == 'shop'
        $state.go('tabs.shop.detail', { id: id })
      else
        $state.go('tabs.shopDetal', { id: id })
