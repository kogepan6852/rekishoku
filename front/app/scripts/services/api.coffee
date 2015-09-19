"use strict"

angular.module("frontApp")
  .factory "Api", ($http) ->

    #host = "http://127.0.0.1:3000"
    host = "http://localhost:3000"

    getPeople: ->
      $http.get(host + "/posts")
        .success (data, status, headers, config) ->

    postPeople: (obj) ->
      $http.post(host + "/posts.json", obj)
        .success (data, status, headers, config) ->

    deletePeople: (id) ->
      $http.delete(host + "/posts/" + id + ".json")
        .success (data, status, headers, config) ->