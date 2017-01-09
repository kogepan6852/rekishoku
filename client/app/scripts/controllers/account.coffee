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
      $scope.init()

    $ionicPopover.fromTemplateUrl('views/parts/popover-favorites.html',
      scope: $scope).then (popoverFavorites) ->
        $scope.popoverFavorites = popoverFavorites

    accessKey =
      email: $localStorage['email']
      token: $localStorage['token']
    
    $scope.isEdit = false;

    # initialize
    $scope.init = ->
      Api.getJson(accessKey, Const.API.FAVORITE, false).then (res) ->
        $scope.favorites = res.data
        if $scope.favorites && $scope.favorites.length > 0
          $scope.selectedFavorite = $scope.favorites[0]
          # get folder detail
          $scope.selectFolder 0

    $scope.openFolderList = ($event) ->
      $scope.popoverFavorites.show($event)

    $scope.selectFolder = (index) ->
      # 編集モードではない場合、表示フォルダを変更
      if !$scope.isEdit
        $scope.selectedFavorite = $scope.favorites[index]
        $scope.popoverFavorites.hide()

        path = Const.API.FAVORITE + '/' + $scope.favorites[index].id
        Api.getJson(accessKey, path, false).then (res) ->
          $scope.favoriteDetails = res.data.favorite_detail
      
      # 編集モードの場合、表示名を更新
      else
        $scope.editData =
          name: $scope.favorites[index].name
        # An elaborate, custom popup
        editFolderPopup = $ionicPopup.show(
          template: '<input type="text" ng-model="editData.name" value="editData.name">'
          title: $translate.instant('MY_ACCOUNT.POPOVER.EDIT.TITLE')
          subTitle: $translate.instant('MY_ACCOUNT.POPOVER.EDIT.MESSAGE')
          scope: $scope
          buttons: [
            { text: $translate.instant('BUTTON.CANCEL') }
            {
              text: '<b>'+$translate.instant('BUTTON.SAVE')+'</b>'
              type: 'btn-main'
              onTap: (e) ->
                if !$scope.editData.name
                  e.preventDefault()
                else
                  return $scope.editData.name
            }
          ])

        editFolderPopup.then (res) ->
          if res
            obj =
              'email': $localStorage['email']
              'token': $localStorage['token']
              'favorite[name]': res

            path = Const.API.FAVORITE + '/' + $scope.favorites[index].id
            Api.postJson(obj, path, false).then (res) ->
              # add data to array
              $scope.favorites[index] = res.data
              # show toast
              toaster.pop
                type: 'success',
                title: $translate.instant('MSG.INFO.UPDATED'),
                showCloseButton: true

              $scope.popoverFavorites.hide()

    $scope.showDelete = ->
      $scope.isDelete = !$scope.isDelete
  
    $scope.$on 'popover.hidden', ->
      $scope.isEdit = false
      $scope.isDelete = false

    $scope.changeMode = ->
      $scope.isEdit = !$scope.isEdit
      if !$scope.isEdit
        $scope.isDelete = false

    $scope.showAddAlert = ->
      $scope.addData = {}
      # An elaborate, custom popup
      addFolderPopup = $ionicPopup.show(
        template: '<input type="text" ng-model="addData.name">'
        title: $translate.instant('MY_ACCOUNT.POPOVER.ADD.TITLE')
        subTitle: $translate.instant('MY_ACCOUNT.POPOVER.ADD.MESSAGE')
        scope: $scope
        buttons: [
          { text: $translate.instant('BUTTON.CANCEL') }
          {
            text: '<b>'+$translate.instant('BUTTON.SAVE')+'</b>'
            type: 'btn-main'
            onTap: (e) ->
              if !$scope.addData.name
                e.preventDefault()
              else
                return $scope.addData.name
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
        title: $translate.instant('MY_ACCOUNT.POPOVER.DELETE.TITLE')
        subTitle: $scope.favorites[index].name + $translate.instant('MY_ACCOUNT.POPOVER.DELETE.MESSAGE')
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
                  'favorite[is_delete]': true
                  'favorite[user_id]': $localStorage['user_id']
                path = Const.API.FAVORITE + '/' + $scope.favorites[index].id
                Api.postJson(obj, path, false).then (res) ->
                  # 表示しているフォルダが削除されているかチェック
                  deleteFlg = false
                  if $scope.selectedFavorite.id == $scope.favorites[index].id
                    deleteFlg = true

                  # delete data from array
                  $scope.favorites.splice(index, 1)

                  # 表示しているフォルダが削除された場合はinit実行
                  if deleteFlg
                    $scope.init()

                  # show toast
                  toaster.pop
                    type: 'success',
                    title: $translate.instant('MSG.INFO.DELETED'),
                    showCloseButton: true

                  $scope.popoverFavorites.hide()
          }
        ])
          