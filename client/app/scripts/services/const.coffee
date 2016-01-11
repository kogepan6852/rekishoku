"use strict"

angular.module("frontApp")
  .factory 'Const', ->
    API:
      POST:         '/api/posts'
      POST_LIST:    '/api/post_list'
      POST_DETSIL:  '/api/post_details'
      POSTS_SHOPS:  '/api/posts_shops'
      PEOPLE_POSTS: '/api/people_posts'
      PERSON_LIST:  '/api/person_list'
      SHOP:         '/api/shops'
      SHOP_LIST:    '/api/shop_list'
      MAP:          '/api/map'
      PERSON:       '/api/people'
      CATEGORY:     '/api/categories'
      USER:         '/api/users'
      LOGIN:        '/users/sign_in.json'
      LOGOUT:       '/authentication_token.json'
      SETTING:
        PER: 20

    MSG:
      SAVED: '投稿しました'
      DELETED: '削除しました'
      UPDATED: '更新しました'
      LOGED_IN: 'ログインしました'
      SINGED_UP: 'アカウントを作成しました'
      PUBLISHED: '公開しました'
      UNPUBLISHED: '非公開にしました'
    METHOD:
      POST: 'POST'
      PATCH: 'PATCH'
