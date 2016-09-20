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
          $sessionStorage['post-category-obj'] = res.data
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
          $sessionStorage['shop-category-obj'] = res.data
          callback res.data

    # shop用categoryの取得
    getFeatureCategory: (callback) ->
      categoryObj = $sessionStorage['feature-category-obj']
      if categoryObj
        callback categoryObj
      else
        featureCategoryObj =
          type: "FeatureCategory"
        Api.getJson(featureCategoryObj, Const.API.CATEGORY, false).then (res) ->
          $sessionStorage['shop-category-obj'] = res.data
          callback res.data

    # people用categoryの取得
    getPeopleCategory: (callback) ->
      categoryObj = $sessionStorage['people-category-obj']
      if categoryObj
        callback categoryObj
      else
        peopleCategoryObj =
          type: "PersonCategory"
        Api.getJson(peopleCategoryObj, Const.API.CATEGORY, false).then (res) ->
          $sessionStorage['people-category-obj'] = res.data
          callback res.data

    # periodの取得
    getPeriod: (callback) ->
      periodObj = $sessionStorage['period-obj']
      if periodObj
        callback periodObj
      else
        Api.getJson(null, Const.API.PERIOD, false).then (res) ->
          $sessionStorage['period-obj'] = res.data
          callback res.data

    # periodの取得
    getPeople: (callback, id) ->
      if !id
        id = 0

      peopleObj = $sessionStorage['people-obj-'+id]
      if peopleObj
        callback peopleObj
      else
        categoryObj = null
        if id
          categoryObj =
            category: id
        Api.getJson(categoryObj, Const.API.PERSON, false).then (res) ->
          $sessionStorage['people-obj-'+id] = res.data
          callback res.data
