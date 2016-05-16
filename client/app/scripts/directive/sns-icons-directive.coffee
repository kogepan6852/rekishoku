"use strict"

angular.module "frontApp"
  .directive 'snsIcons', (config, $location) ->
    return {
      restrict: 'E'
      scope:
        imageUrl: '=imageUrl'
        title: '=title'
        description: '=description'
      templateUrl: 'views/directives/sns-icons-directive.html'
      link: (scope, element, attrs) ->
        # FB設定
        FB.init
          appId: config.id.fb
          status: true
          cookie: true
        # URL設定
        urlFb = config.url.home + $location.url()
        urlTwitter = config.url.home + $location.url()

        scope.postToFeed = ->
          obj =
            display: 'popup'
            method: 'share'
            href: urlFb
            picture: scope.imageUrl
            title: scope.title
            caption: '歴食.jp'
            description: scope.description
          FB.ui obj
    }
