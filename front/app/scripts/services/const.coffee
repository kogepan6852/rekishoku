"use strict"

angular.module("frontApp")
  .factory 'Const', ->
    API:
      POST: '/posts'
      LOGIN: '/users/sign_in.json'
      USER: '/users'
    MSG:
      SAVED: '投稿しました'
      DELETED: '削除しました'
      LOGED_IN: 'ログインしました'
      SINGED_UP: 'アカウントを作成しました'
