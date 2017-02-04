"use strict"

angular.module "frontApp"
  .directive 'listItemShop', ->
    return {
      restrict: 'E'
      scope:
        data: '=data'
        categories: '=categories'
        people: '=people'
        price: '=price'
        rating: '=rating'
        hideInfo: '=hideInfo'
        windowType: '=windowType'
      templateUrl: 'views/directives/list-item-directive.html'
      link: (scope, element, attrs) ->
        scope.periods = [{
          id: scope.data.period_id,
          name: scope.data.period_name
        }];
        scope.target = "shop"
        scope.mainImage = scope.data.subimage;
        scope.href = "/app/shop/" + scope.data.id
    }
