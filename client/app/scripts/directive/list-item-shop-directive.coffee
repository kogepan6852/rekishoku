"use strict"

angular.module "frontApp"
  .directive 'listItemShop', ->
    return {
      restrict: 'E'
      scope:
        data: '=data'
        periods: '=periods'
        people: '=people'
        rating: '=rating'
      templateUrl: 'views/directives/list-item-directive.html'
      link: (scope, element, attrs) ->
        scope.target = "shop"
    }
