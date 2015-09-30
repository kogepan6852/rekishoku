"use strict"

angular.module("frontApp")
  .factory "Api", ($http, toaster) ->

    #host = "http://127.0.0.1:3000"
    host = "http://localhost:3000"

    getPostList: (obj) ->
      $http(
        method: 'GET'
        url: host + "/posts"
        params: obj
        ).success (data, status, headers, config) ->

    getPostListAll: () ->
      $http(
        method: 'GET'
        url: host + "/posts"
        ).success (data, status, headers, config) ->

    postPostList: (fd) ->
      $http(
        method: 'POST'
        url: host + "/posts.json"
        transformRequest: null
        headers: 'Content-type': undefined
        data: fd
        ).success (data, status, headers, config) ->
          toaster.pop
            type: 'success',
            title: '投稿しました',
            showCloseButton: true


    deletePostList: (id, obj) ->
      $http(
        method: 'DELETE'
        url: host + "/posts/" + id + ".json"
        params: obj
        ).success (data, status, headers, config) ->
          toaster.pop
            type: 'success',
            title: '削除しました',
            showCloseButton: true

    getAccessToken: (obj) ->
      $http(
        method: 'POST'
        url: host + "/users/sign_in.json"
        data: obj
        ).success (data, status, headers, config) ->

    postUser: (obj) ->
      $http(
        method: 'POST'
        url: host + "/users.json"
        data: obj
      ).success (data, status, headers, config) ->
