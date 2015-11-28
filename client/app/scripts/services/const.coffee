"use strict"

angular.module("frontApp")
  .factory 'Const', ->
    API:
      POST: '/posts'
      POST_DETSIL: '/post_details'
      SHOP: '/shops'
      PERSON: '/people/api'
      LOGIN: '/users/sign_in.json'
      LOGOUT: '/authentication_token.json'
      USER: '/users'
      CATEGORY: '/categories.json'
      POST_SHOP: '/posts_shops'
      POST_PERSON: '/people_posts'
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
