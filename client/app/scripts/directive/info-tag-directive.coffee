"use strict"

angular.module "frontApp"
  .directive 'infoTag', ->
    return {
      restrict: 'E'
      scope:
        name: '@'
      templateUrl: 'views/directives/info-tag-directive.html'
      link: (scope, element, attrs) ->
    }
