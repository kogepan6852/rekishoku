"use strict"

angular.module("frontApp")
  .factory "Api", ($http) ->

    #host = "http://127.0.0.1:3000"
    host = "http://localhost:3000"

    getPostList: (obj) ->
      $http(
        method: 'GET'
        url: host + "/posts"
        params: obj
        ).success (data, status, headers, config) ->

    postPostList: (obj) ->
      $http(
        method: 'POST'
        url: host + "/posts.json"
        data: obj
        ).success (data, status, headers, config) ->

    deletePostList: (id) ->
      $http.delete(host + "/posts/" + id + ".json")
        .success (data, status, headers, config) ->

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
