'use strict'

###*
 # @ngdoc function
 # @name frontApp.controller:AccountCtrl
 # @description
 # AccountCtrl
 # Controller of the frontApp
###
angular.module "frontApp"
  .controller "AccountCtrl", ($scope, $controller, Api, Const, $translate, $ionicNavBarDelegate, $localStorage, $ionicPopover, $ionicPopup, toaster) ->

    # Controllerの継承
    $controller 'BaseCtrl', $scope: $scope

    # setting
    $scope.$on '$ionicView.enter', (e) ->
      $ionicNavBarDelegate.showBackButton true
      # get folder list
      Api.getJson(accessKey, Const.API.FAVORITE, false).then (res) ->
        $scope.favorites = res.data
        if $scope.favorites && $scope.favorites.length > 0
          $scope.selectedFavorite = $scope.favorites[0]
          # get folder detail
          $scope.selectFolder 0


    $ionicPopover.fromTemplateUrl('views/parts/popover-favorites.html',
      scope: $scope).then (popoverFavorites) ->
        $scope.popoverFavorites = popoverFavorites

    accessKey =
      email: $localStorage['email']
      token: $localStorage['token']
    
    $scope.isEdit = false;

    # initialize
    $scope.init = ->
      # $scope.favoriteDetails = 
    
    $scope.openFolderList = ($event) ->
      $scope.popoverFavorites.show($event)

    $scope.selectFolder = (index) ->
      $scope.selectedFavorite = $scope.favorites[index]
      $scope.popoverFavorites.hide()

      path = Const.API.FAVORITE + '/' + $scope.favorites[index].id
      Api.getJson(accessKey, path, false).then (res) ->
        $scope.favoriteDetails = res.data.favorite_detail

    $scope.showEdit = ->
      $scope.isEdit = !$scope.isEdit
  
    $scope.$on 'popover.hidden', ->
      $scope.isEdit = false

    $scope.showAddAlert = ->
      $scope.data = {}
      # An elaborate, custom popup
      addFolderPopup = $ionicPopup.show(
        template: '<input type="text" ng-model="data.name">'
        title: '新規リストの追加'
        subTitle: 'リスト名を入力してください'
        scope: $scope
        buttons: [
          { text: 'Cancel' }
          {
            text: '<b>'+$translate.instant('BUTTON.SAVE')+'</b>'
            type: 'btn-main'
            onTap: (e) ->
              if !$scope.data.name
                e.preventDefault()
              else
                return $scope.data.name
          }
        ])

      addFolderPopup.then (res) ->
        if res
          obj =
            'email': $localStorage['email']
            'token': $localStorage['token']
            'favorite[name]': res
            'favorite[user_id]': $localStorage['user_id']
            'favorite[order]': $scope.favorites.length

          Api.postJson(obj, Const.API.FAVORITE, false).then (res) ->
            # add data to array
            $scope.favorites.push res.data
            # show toast
            toaster.pop
              type: 'success',
              title: $translate.instant('MSG.INFO.SAVED'),
              showCloseButton: true

            $scope.popoverFavorites.hide()

      
    $scope.showDeleteAlert = (index) ->
      deleteFolderPopup = $ionicPopup.show(
        title: 'リストの削除'
        subTitle: $scope.favorites[index].name + 'を削除してもよろしいですか？'
        scope: $scope
        buttons: [
          { text: 'Cancel' }
          {
            text: '<b>'+$translate.instant('BUTTON.OK')+'</b>'
            type: 'btn-main'
            onTap: (e) ->
              if $scope.favorites && $scope.favorites.length > 1
                obj =
                  'email': $localStorage['email']
                  'token': $localStorage['token']
                Api.deleteJson(obj, $scope.favorites[index].id, Const.API.FAVORITE).then (res) ->
                  # delete data from array
                  $scope.favorites.splice(index, 1)
                  # show toast
                  toaster.pop
                    type: 'success',
                    title: $translate.instant('MSG.INFO.DELETED'),
                    showCloseButton: true

                  $scope.popoverFavorites.hide()
          }
        ])
          