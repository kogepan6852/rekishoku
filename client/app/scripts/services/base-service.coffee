"use strict"

angular.module "frontApp"
  .factory "BaseService", ($ionicPopup, Const) ->

    # GoogleMapの距離計算
    calMapDistance: (zoom) ->
      meterPerPx = Const.MAP.METER_PER_PX
      # GoogleMap上の1pxあたりのmを求める
      targetMeterPerPx = meterPerPx/Math.pow(2, zoom - 9)
      # 画面幅に応じてGoogleMap横(または縦)の距離を求める
      clientPx = document.body.clientWidth
      if document.body.clientHeight > document.body.clientWidth
        clientPx = document.body.clientHeight
      targetDistance = (clientPx - 100) * targetMeterPerPx

      return targetDistance

    # geocoderによる緯度経度の取得
    getLatLng: (address, callback) ->
      geocoder = new google.maps.Geocoder();
      geocoder.geocode { address: address }, (result, status) ->
        if status == google.maps.GeocoderStatus.OK
          latLng =
            lat: result[0].geometry.location.lat()
            lng: result[0].geometry.location.lng()
          callback(latLng)
        else
          alertPopup = $ionicPopup.alert(
            title: '通信エラーが発生しました'
            type: 'button-dark')
          alertPopup.then (res) ->

    # 配列をランダムで取得する
    getRandomArray: (array, num) ->
      a = array
      t = []
      r = []
      l = a.length
      n = if num < l then num else l
      while n-- > 0
        i = Math.random() * l | 0
        r[n] = t[i] || a[i]
        --l
        t[i] = t[l] || a[l]
      return r

    # 距離からzoomを求める
    getZoomByDistance: (latDistance, lngDistance) ->
      # 画面幅ごとのmap表示領域の調整
      clientPx = document.body.clientWidth
      targetWidth = 220
      if clientPx > 768
        targetWidth = 320
      # zoomの計算
      latZoom = Math.LOG2E * Math.log((targetWidth * Const.MAP.METER_PER_PX * Const.MAP.LAT_PER_METER) / latDistance ) + 9
      lngZoom = Math.LOG2E * Math.log((targetWidth * Const.MAP.METER_PER_PX * Const.MAP.LAT_PER_METER) / lngDistance ) + 9
      rtn = Math.floor(latZoom)
      if latZoom > lngZoom
        rtn = Math.floor(lngZoom)

      return rtn
