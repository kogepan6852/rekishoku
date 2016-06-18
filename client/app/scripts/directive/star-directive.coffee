"use strict"

angular.module "frontApp"
  .directive 'star', ->
    return {
      restrict: 'E'
      scope:
        label: '=label'
        count: '=count'
      templateUrl: 'views/directives/star-directive.html'
      link: (scope, element, attrs) ->
        scope.$watch 'count', ->
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