"use strict"

angular.module "frontApp"
  .directive 'listItemFeature', ->
    return {
      restrict: 'E'
      scope:
        data: '=data'
        periods: '=periods'
        people: '=people'
        category: '=category'
        windowType: '=windowType'
      templateUrl: 'views/directives/list-item-directive.html'
      link: (scope, element, attrs) ->
        scope.target = "feature"
        scope.mainImage = scope.data.image;
        scope.href = "/app/feature/" + scope.data.id
    }
