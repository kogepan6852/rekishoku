"use strict"

angular.module "frontApp"
  .directive 'star', ($translate) ->
    return {
      restrict: 'E'
      scope:
        label: '=label'
        count: '=count'
        type: '@type'
      templateUrl: 'views/directives/star-directive.html'
      link: (scope, element, attrs) ->
        scope.$watch 'count', ->
          # ラベルの設定
          if scope.type == "history"
            scope.title = $translate.instant('SHOP.RATING.INFO.HISTORY.TITLE')
          else if scope.type == "building"
            scope.title = $translate.instant('SHOP.RATING.INFO.BUILDING.TITLE')
          else if scope.type == "menu"
            scope.title = $translate.instant('SHOP.RATING.INFO.MENU.TITLE')
          else if scope.type == "person"
            scope.title = $translate.instant('SHOP.RATING.INFO.PERSON.TITLE')
          else if scope.type == "episode"
            scope.title = $translate.instant('SHOP.RATING.INFO.EPISODE.TITLE')
          else
            scope.title = $translate.instant('SHOP.HF_RATING')

          # 星ありの数
          starCount = Math.floor(scope.count);  # 整数部の取得
          stars = []
          i = 0
          while i < starCount
            stars.push "ion-android-star"
            i++

          # 星半分の数
          halfStarCount = 0;
          if (scope.count - starCount) >= 0.8
            starCount += 1
            stars.push "ion-android-star"

          else if (scope.count - starCount) >= 0.3
            halfStarCount = 1
            stars.push "ion-android-star-half"

          # 星なしの数
          nonStarCount = 3 - starCount - halfStarCount;
          i = 0
          while i < nonStarCount
            stars.push "ion-android-star-outline"
            i++

          scope.stars = stars
    }
