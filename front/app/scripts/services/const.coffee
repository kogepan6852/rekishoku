"use strict"

angular.module("frontApp")
  .factory 'Const', ->
    API:
      POST: '/posts'
      POST_DETSIL: '/post_details'
      LOGIN: '/users/sign_in.json'
      LOGOUT: '/authentication_token.json'
      USER: '/users'
      CATEGORY: '/categories.json'
    MSG:
      SAVED: '投稿しました'
      DELETED: '削除しました'
      UPDATED: '更新しました'
      LOGED_IN: 'ログインしました'
      SINGED_UP: 'アカウントを作成しました'
    METHOD:
      POST: 'POST'
      PATCH: 'PATCH'
