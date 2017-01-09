"use strict"

angular.module "frontApp"
  .directive 'favoriteButton', (Api, Const, $localStorage, $ionicPopover) ->
    return {
      restrict: 'E'
      scope:
        type: '@'
        id: '@'
      templateUrl: 'views/directives/favorite-button-directive.html'
      link: (scope, element, attrs) ->
        scope.isFavorite = false
        scope.hideFavoriteHeader = true

        $ionicPopover.fromTemplateUrl('views/parts/popover-favorites.html',
          scope: scope).then (popoverFavorites) ->
            scope.popoverFavorites = popoverFavorites

        getObj =
          'email': $localStorage['email']
          'token': $localStorage['token']
          'favorite_detail[related_type]': scope.type
          'favorite_detail[related_id]': scope.id
        
        # お気に入りの状態を取得する
        Api.getJson(getObj, Const.API.FAVORITE_DETAIL, false).then (res) ->
          if res.data
            scope.favoriteDetail = res.data
            scope.isFavorite = true
        
        # お気に入りフォルダを保存する
        saveFavorite = (id) ->
          postObj =
            'email': $localStorage['email']
            'token': $localStorage['token']
            'favorite_detail[related_type]': scope.type
            'favorite_detail[related_id]': scope.id
            'favorite_detail[is_delete]': scope.isFavorite
            'favorite_detail[favorite_id]': id

          Api.postJson(postObj, Const.API.FAVORITE_DETAIL, false).then (res) ->
            scope.isFavorite = !scope.isFavorite

        # popoverのリストチェック時のアクション
        scope.check = ($event) ->
          if scope.isFavorite && scope.favoriteDetail
            # お気に入り解除
            saveFavorite(scope.favoriteDetail.favorite_id)
          else
            # お気に入り設定
            accessKey =
              'email': $localStorage['email']
              'token': $localStorage['token']

            Api.getJson(accessKey, Const.API.FAVORITE, false).then (res) ->
              scope.favorites = res.data

              # Favoritesが1個以上ある場合は、popoverで対象を選択する
              if scope.favorites.length > 1
                scope.popoverHeight = (17 + 54 * scope.favorites.length) + 'px'
                scope.popoverFavorites.show($event)
              else
                saveFavorite scope.favorites[0].id

        # 選択したお気に入りフォルダにお気に入りを保存する
        scope.selectFolder = ($index) ->
          saveFavorite scope.favorites[$index].id
          scope.popoverFavorites.hide()
    }
