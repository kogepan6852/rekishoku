"use strict"

angular.module "frontApp"
  .factory "BaseService", ($ionicPopup) ->

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
