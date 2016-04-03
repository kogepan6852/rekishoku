"use strict"

angular.module("frontApp")
  .factory 'Const', ->
    API:
      POST:         '/api/posts'
      POST_LIST:    '/api/post_list'
      POST_DETSIL:  '/api/post_details'
      POSTS_SHOPS:  '/api/posts_shops'
      POSTS_RELATED:'/api/posts_related'
      PEOPLE_POSTS: '/api/people_posts'
      PERSON_LIST:  '/api/person_list'
      SHOP:         '/api/shops'
      SHOP_LIST:    '/api/shop_list'
      MAP:          '/api/map'
      PERSON:       '/api/people'
      CATEGORY:     '/api/categories'
      PERIOD:       '/api/periods'
      USER:         '/api/users'
      LOGIN:        '/users/sign_in.json'
      LOGOUT:       '/authentication_token.json'
      SETTING:
        PER: 20

    METHOD:
      POST: 'POST'
      PATCH: 'PATCH'
