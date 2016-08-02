"use strict"

angular.module "frontApp"
  .directive 'listItemExternalLink', ($window) ->
    return {
      restrict: 'E'
      scope:
        data: '=data'
        windowType: '=windowType'
        showLink: '=showLink'
      templateUrl: 'views/directives/list-item-directive.html'
      link: (scope, element, attrs) ->
        scope.target = "externalLink"

        scope.openLink = ->
          $window.open scope.data.quotation_url
          return true
    }
