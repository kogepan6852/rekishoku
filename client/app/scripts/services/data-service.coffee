"use strict"

angular.module "frontApp"
  .factory "DataService", (Api, Const, $sessionStorage) ->

    # post用categoryの取得
    getPostCategory: (callback) ->
      categoryObj = $sessionStorage['post-category-obj']
      if categoryObj
        callback categoryObj
      else
        postCategoryObj =
          type: "PostCategory"
        Api.getJson(postCategoryObj, Const.API.CATEGORY, false).then (res) ->
          callback res.data

    # shop用categoryの取得
    getShopCategory: (callback) ->
      categoryObj = $sessionStorage['shop-category-obj']
      if categoryObj
        callback categoryObj
      else
        shopCategoryObj =
          type: "ShopCategory"
        Api.getJson(shopCategoryObj, Const.API.CATEGORY, false).then (res) ->
          callback res.data

    # periodの取得
    getPeriod: (callback) ->
      periodObj = $sessionStorage['period-obj']
      if periodObj
        callback periodObj
      else
        Api.getJson(null, Const.API.PERIOD, false).then (res) ->
          callback res.data
