'use strict'

###*
 # @ngdoc function
 # @name frontApp.controller:AccountCtrl
 # @description
 # AccountCtrl
 # Controller of the frontApp
###
angular.module "frontApp"
  .controller "AccountCtrl", ($scope, $rootScope, $ionicSideMenuDelegate, $controller, Api, Const, $translate, $ionicNavBarDelegate) ->

    # Controllerの継承
    $controller 'BaseCtrl', $scope: $scope

    # setting
    $scope.$on '$ionicView.enter', (e) ->
      $ionicNavBarDelegate.showBackButton true

    # initialize
    $scope.init = ->
      # Api.getJson("", Const.API.USER, false).then (res) ->
      #   $scope.users = res.data
      #   $scope.$broadcast 'scroll.refreshComplete'
      $scope.favorites = [
        {
          'post':
            'id': 6
            'title': 'テスト投稿３'
            'content': 'ここにテキスト。ここにテキスト。ここにテキスト。ここにテキスト。ここにテキスト。ここにテキスト。ここにテキスト。ここにテキスト。ここにテキスト。ここにテキスト。'
            'image':
              'url': 'http://localhost:3000/uploads/post/image/6/lg_tokai-top.jpg'
              'thumb': 'url': 'http://localhost:3000/uploads/post/image/6/thumb_lg_tokai-top.jpg'
              'sm': 'url': 'http://localhost:3000/uploads/post/image/6/sm_lg_tokai-top.jpg'
              'md': 'url': 'http://localhost:3000/uploads/post/image/6/md_lg_tokai-top.jpg'
              'lg': 'url': 'http://localhost:3000/uploads/post/image/6/lg_lg_tokai-top.jpg'
              'xl': 'url': 'http://localhost:3000/uploads/post/image/6/xl_lg_tokai-top.jpg'
              'w640': 'url': 'http://localhost:3000/uploads/post/image/6/w640_lg_tokai-top.jpg'
              'w960': 'url': 'http://localhost:3000/uploads/post/image/6/w960_lg_tokai-top.jpg'
              'w1200': 'url': 'http://localhost:3000/uploads/post/image/6/w1200_lg_tokai-top.jpg'
            'published_at': '2017-01-08T00:00:00.000Z'
            'category_id': 1
            'category_name': 'EPISODE'
            'category_slug': 'episode'
          'people': []
          'periods': []
        }
        {
          'post':
            'id': 4
            'title': 'aaa'
            'content': 'aaaa'
            'image':
              'url': 'http://localhost:3000/uploads/post/image/4/thumb_ougiya.jpg'
              'thumb': 'url': 'http://localhost:3000/uploads/post/image/4/thumb_thumb_ougiya.jpg'
              'sm': 'url': 'http://localhost:3000/uploads/post/image/4/sm_thumb_ougiya.jpg'
              'md': 'url': 'http://localhost:3000/uploads/post/image/4/md_thumb_ougiya.jpg'
              'lg': 'url': 'http://localhost:3000/uploads/post/image/4/lg_thumb_ougiya.jpg'
              'xl': 'url': 'http://localhost:3000/uploads/post/image/4/xl_thumb_ougiya.jpg'
              'w640': 'url': 'http://localhost:3000/uploads/post/image/4/w640_thumb_ougiya.jpg'
              'w960': 'url': 'http://localhost:3000/uploads/post/image/4/w960_thumb_ougiya.jpg'
              'w1200': 'url': 'http://localhost:3000/uploads/post/image/4/w1200_thumb_ougiya.jpg'
            'published_at': '2017-01-07T00:00:00.000Z'
            'category_id': 1
            'category_name': 'EPISODE'
            'category_slug': 'episode'
          'people': []
          'periods': []
        }
      ]
    
    $scope.openFolderList = ->
      console.log 'open!!'