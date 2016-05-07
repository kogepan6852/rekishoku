"use strict"

angular.module "frontApp"
  .directive 'advertismentRow', (Const, $timeout) ->
    return {
      restrict: 'E'
      scope:
        seed: '@seed'
      templateUrl: 'views/directives/advertisment-row-directive.html'
      link: (scope, element, attrs) ->
        $timeout (->
          adsLg = Const.ADS.AD300X250
          adsMd = Const.ADS.AD468X60
          adsSm = Const.ADS.AD125X125

          i = Math.floor(Math.random() * adsLg.length)
          j = Math.floor(Math.random() * adsLg.length)
          while i == j
            j = Math.floor(Math.random() * adsLg.length)

          scope.ads =
            lg: adsLg[i] + '　' + adsLg[j]
            md: adsMd[i] + '<br>' + adsMd[j]
            sm: adsSm[i] + '　' + adsSm[j]
        ), scope.seed
    }
