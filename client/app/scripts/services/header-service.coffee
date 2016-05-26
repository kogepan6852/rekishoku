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
        $ionicScrollDelegate.$getByHandle('magazine').scrollTop();

      $ionicSlideBoxDelegate.previous()
      $ionicSideMenuDelegate.toggleRight(false);

    # 検索用都道府県の取得
    getProvinces: ->
      provinces = $translate.instant('PROVINCES').split(',')
      provincesObj = []

      angular.forEach provinces, (province, i) ->
        obj = {id: province, name: province}
        provincesObj.push obj

      return provincesObj
