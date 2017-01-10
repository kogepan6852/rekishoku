"use strict"

angular.module "frontApp"
  .factory "FasebookService", ($q) ->
    # common function
    signup = ->
      deferred = $q.defer()

      FB.login ((response) ->
        if response.authResponse
          FB.api '/me?fields=name,email', (responseApi) ->
            fbInfo = 
              userID: response.authResponse.userID
              accessToken: response.authResponse.accessToken
              email: responseApi.email
            deferred.resolve fbInfo
        else
          deferred.reject response.error
      ), scope: 'email'

      return deferred.promise

    getInfo = ->
      deferred = $q.defer()

      FB.api '/me?fields=name,email', (response) ->
        if !response || response.error
          deferred.reject response.error
        else
          deferred.resolve response

      return deferred.promise

    # signup
    signup: ->
      return signup()

    # login
    login: ->
      deferred = $q.defer()
      FB.getLoginStatus (response) ->
        if response.status == 'connected'
          uid = response.authResponse.userID
          accessToken = response.authResponse.accessToken
          # get user info from facebook
          getInfo().then(
            (responseInfo) -> 
              fbInfo = 
                userID: response.authResponse.userID
                accessToken: response.authResponse.accessToken
                email: responseInfo.email
              deferred.resolve fbInfo
            (error) -> deferred.reject error            
          )

        else if response.status == 'not_authorized'
          # the user is logged in to Facebook, 
          # but has not authenticated your app
          signup().then(
            (responseSignup) -> 
              deferred.resolve responseSignup
            (error) -> deferred.reject error
          )

        else
          deferred.reject()

      return deferred.promise
