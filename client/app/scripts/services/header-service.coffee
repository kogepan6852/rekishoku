"use strict"

angular.module "frontApp"
  .factory "HeaderService", ($rootScope, $location, $ionicScrollDelegate, $ionicSlideBoxDelegate, $ionicSideMenuDelegate, $translate) ->

    # 各条件による検索
    searchByConditions: (id, target) ->
      # shop検索
      if $rootScope.currentType == 'shop'
        $location.path('/app/shop/list').search(target, id)
        if $rootScope.shopsSearch
          $rootScope.shopsSearch()
        # TOPへScroll
        $ionicScrollDelegate.$getByHandle('shops').scrollTop();

      # map検索
      else if $rootScope.currentType == 'map'
        $location.path('/app/shop/map').search(target, id)
        if $rootScope.mapSearch
          $rootScope.mapSearch()

      # post検索
      else
        $rootScope.currentType = 'magazine'
        $location.path('/app/magazine').search(target, id)
        if $rootScope.postsSearch
          $rootScope.postsSearch()
        # TOPへScroll
        $ionicScrollDelegate.$getByHandle('magazine').scrollTop()

      $ionicSlideBoxDelegate.slide(0)
      $ionicSideMenuDelegate.toggleRight(false);

    # 検索用都道府県エリアの取得
    getProvincesArea: ->
      provincesArea = $translate.instant('PROVINCES.AREA').split(',')
      provincesAreaObj = []

      angular.forEach provincesArea, (province, i) ->
        obj = {id: province, name: province}
        provincesAreaObj.push obj

      return provincesAreaObj

    # 検索用都道府県の取得
    getProvinces: (index) ->
      provinces = $translate.instant('PROVINCES.' + index).split(',')
      provincesObj = []

      angular.forEach provinces, (province, i) ->
        obj = {id: province, name: province}
        provincesObj.push obj

      return provincesObj
