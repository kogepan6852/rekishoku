"use strict"

angular.module "frontApp"
  .factory "BaseService", ->

    # GoogleMapの距離計算
    calMapDistance: (zoom) ->
      meterPerPx = 60
      # GoogleMap上の1pxあたりのmを求める
      targetMeterPerPx = meterPerPx/(zoom - 10)
      # 画面幅に応じてGoogleMap横(または縦)の距離を求める
      clientPx = document.body.clientWidth
      if document.body.clientHeight > document.body.clientWidth
        clientPx = document.body.clientHeight
      targetDistance = (clientPx - 100) * targetMeterPerPx

      return targetDistance
