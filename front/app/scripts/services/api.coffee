"use strict"

angular.module "frontApp"
  .factory "Api", ($http, $ionicPopup, $ionicLoading, toaster, Const, config) ->

    host = config.url.api

    # エラー発生時処理
    errorHandring = (data) ->
      if data.error
        alertPopup = $ionicPopup.alert(
          title: data.error
          type: 'button-dark')
        alertPopup.then (res) ->
      else
        alertPopup = $ionicPopup.alert(
          title: '通信エラーが発生しました'
          type: 'button-dark')
        alertPopup.then (res) ->

    # data取得(GET)
    getJson: (obj, path) ->
      $ionicLoading.show(
        template: '<ion-spinner icon="ios"></ion-spinner><br>Loading...'
        delay: 500)
      $http(
        method: 'GET'
        url: host + path
        params: obj
      ).success((data, status, headers, config) ->
        $ionicLoading.hide()
      ).error (data, status, headers, config) ->
        $ionicLoading.hide()
        errorHandring(data)

    # data取得(POST)
    postJson: (obj, path) ->
      $ionicLoading.show(
        template: '<ion-spinner icon="ios"></ion-spinner><br>Loading...'
        delay: 500)
      $http(
        method: 'POST'
        url: host + path
        data: obj
      ).success((data, status, headers, config) ->
        $ionicLoading.hide()
      ).error (data, status, headers, config) ->
        $ionicLoading.hide()
        errorHandring(data)


    # data登録(POST, JSON)
    saveJson: (obj, path, method) ->
      $ionicLoading.show template: '<ion-spinner icon="ios"></ion-spinner><br>Loading...'
      $http(
        method: method
        url: host + path + ".json"
        data: obj
      ).success((data, status, headers, config) ->
        $ionicLoading.hide()
      ).error (data, status, headers, config) ->
        $ionicLoading.hide()
        errorHandring(data)

    # data登録(POST, FORM DATA)
    saveFormData:(fd, path, method) ->
      $ionicLoading.show template: '<ion-spinner icon="ios"></ion-spinner><br>Loading...'
      $http(
        method: method
        url: host + path + ".json"
        transformRequest: null
        headers: 'Content-type': undefined
        data: fd
      ).success((data, status, headers, config) ->
        $ionicLoading.hide()
      ).error (data, status, headers, config) ->
        $ionicLoading.hide()
        errorHandring(data)

    # data削除(DELETE)
    deleteJson: (obj, id, path) ->
      $ionicLoading.show template: '<ion-spinner icon="ios"></ion-spinner><br>Loading...'
      $http(
        method: 'DELETE'
        url: host + path + "/" + id + ".json"
        params: obj
      ).success((data, status, headers, config) ->
        $ionicLoading.hide()
      ).error (data, status, headers, config) ->
        $ionicLoading.hide()
        errorHandring(data)

    # data削除(DELETE)
    logOut: (obj, path) ->
      $http(
        method: 'DELETE'
        url: host + path
        params: obj
      ).success((data, status, headers, config) ->
        toaster.pop
          type: 'success',
          title: 'ログアウトしました',
          showCloseButton: true
      ).error (data, status, headers, config) ->
        errorHandring(data)
