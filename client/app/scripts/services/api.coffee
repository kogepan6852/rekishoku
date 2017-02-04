"use strict"

angular.module "frontApp"
  .factory "Api", ($http, $ionicPopup, $ionicLoading, toaster, Const, config, $rootScope, $localStorage) ->

    host = config.url.api
    
    successHandring = (data) ->
      $ionicLoading.hide()

    # エラー発生時処理
    errorHandring = (data, status) ->
      if data && data.error
        alertPopup = $ionicPopup.alert(
          title: data.error
          type: 'btn-main')
        alertPopup.then (res) ->

        # 認証エラーの場合
        if status == 401
          # login情報の削除
          delete $localStorage['token']
          delete $localStorage['email']
          delete $localStorage['user_id']

          $rootScope.isLogin = false
          $rootScope.isWriter = false

      else
        alertPopup = $ionicPopup.alert(
          title: '通信エラーが発生しました'
          type: 'btn-main')
        alertPopup.then (res) ->

    # data取得(GET)
    getJson: (obj, path, isLoading) ->
      if isLoading
        $ionicLoading.show template: '<ion-spinner icon="ios"></ion-spinner><br>Loading...'
      $http(
        method: 'GET'
        url: host + path
        params: obj
      ).success((data, status, headers, config) ->
        successHandring data
      ).error (data, status, headers, config) ->
        $ionicLoading.hide()
        errorHandring data, status

    # data取得(POST)
    postJson: (obj, path, isLoading) ->
      if isLoading
        $ionicLoading.show template: '<ion-spinner icon="ios"></ion-spinner><br>Loading...'
      $http(
        method: 'POST'
        url: host + path
        data: obj
      ).success((data, status, headers, config) ->
        successHandring data
      ).error (data, status, headers, config) ->
        $ionicLoading.hide()
        errorHandring data, status

    # data更新(PATCH)
    patchJson: (obj, path, isLoading) ->
      if isLoading
        $ionicLoading.show template: '<ion-spinner icon="ios"></ion-spinner><br>Loading...'
      $http(
        method: 'PATCH'
        url: host + path
        data: obj
      ).success((data, status, headers, config) ->
        successHandring data
      ).error (data, status, headers, config) ->
        $ionicLoading.hide()
        errorHandring data, status


    # data登録(POST, JSON)
    saveJson: (obj, path, method) ->
      $ionicLoading.show template: '<ion-spinner icon="ios"></ion-spinner><br>Loading...'
      $http(
        method: method
        url: host + path + ".json"
        data: obj
      ).success((data, status, headers, config) ->
        successHandring data
      ).error (data, status, headers, config) ->
        $ionicLoading.hide()
        errorHandring data, status

    # data登録(POST, FORM DATA)
    saveFormData:(fd, path, method) ->
      $ionicLoading.show template: '<ion-spinner icon="ios"></ion-spinner><br>Loading...'
      $http(
        method: method
        url: host + path
        transformRequest: null
        headers: 'Content-type': undefined
        data: fd
      ).success((data, status, headers, config) ->
        successHandring data
      ).error (data, status, headers, config) ->
        $ionicLoading.hide()
        errorHandring data, status

    # data削除(DELETE)
    deleteJson: (obj, id, path) ->
      $ionicLoading.show template: '<ion-spinner icon="ios"></ion-spinner><br>Loading...'
      $http(
        method: 'DELETE'
        url: host + path + "/" + id + ".json"
        params: obj
      ).success((data, status, headers, config) ->
        successHandring data
      ).error (data, status, headers, config) ->
        $ionicLoading.hide()
        errorHandring data, status

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
        errorHandring data, status
