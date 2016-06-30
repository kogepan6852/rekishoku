"use strict"

angular.module "frontApp"
  .directive 'resize', ($timeout, $rootScope, $window) ->
    link: ->
      timer = false
      angular.element($window).on 'load resize', (e) ->
        if timer then $timeout.cancel timer

        timer = $timeout ->

          # ウィンドウのサイズを取得
          html = angular.element(document).find('html')
          cW = html[0].clientWidth

          if cW >= 1200
            windowType = 'lg'
          else if cW >= 992
            windowType = 'md'
          else if cW >= 768
            windowType = 'sm'
          else
            windowType = 'xs'

          $rootScope.$broadcast 'resize::resize', windowType: windowType

        , 200
