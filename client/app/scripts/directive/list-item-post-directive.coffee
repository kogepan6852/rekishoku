"use strict"

angular.module "frontApp"
  .directive 'listItemPost', ->
    return {
      restrict: 'E'
      scope:
        data: '=data'
        periods: '=periods'
        people: '=people'
        category: '=category'
      templateUrl: 'views/directives/list-item-directive.html'
      link: (scope, element, attrs) ->
        scope.target = "post"
        # レイアウトのリサイズを検知
        scope.$on 'resize::resize', (event, args) ->
          scope.windowType = args.windowType

    }
