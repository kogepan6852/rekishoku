"use strict"

angular.module("frontApp")
  .factory 'Const', ->
    API:
      POST: '/posts'
      POST_DETSIL: '/post_details'
      POST_SHOP: '/posts_shops'
      POST_PERSON: '/people_posts'
      POST_API: '/api_post/posts'
      POST_DETSIL_API: '/api_post/post_details'
      POST_SHOP_API: '/api_post/posts_shops'
      POST_PERSON_API: '/api_post/people_posts'
      SHOP: '/api_shop/shops'
      PERSON: '/api_people/people'
      LOGIN: '/users/sign_in.json'
      LOGOUT: '/authentication_token.json'
      USER: '/users'
      CATEGORY: '/api_post/categories.json'

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
    URL:
      GOOGLE_MAP: 'http://maps.google.co.jp/maps?t=m&z=16&q='
