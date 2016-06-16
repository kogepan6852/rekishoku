"use strict"

angular.module "frontApp"
  .directive 'listItemShop', ->
    return {
      restrict: 'E'
      scope:
        data: '=data'
        categories: '=categories'
        periods: '=periods'
        people: '=people'
        price: '=price'
        rating: '=rating'
        hideInfo: '=hideInfo'
      templateUrl: 'views/directives/list-item-directive.html'
      link: (scope, element, attrs) ->
        scope.target = "shop"
    }
