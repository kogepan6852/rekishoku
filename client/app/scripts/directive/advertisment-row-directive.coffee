"use strict"

angular.module "frontApp"
  .directive 'advertismentRow', (Const, $timeout) ->
    return {
      restrict: 'E'
      scope:
        seed: '@seed'
      templateUrl: 'views/directives/advertisment-row-directive.html'
      link: (scope, element, attrs) ->
    }
