'use strict'

###*
 # @ngdoc function
 # @name frontApp.controller:HeaderCtrl
 # @description
 # # HeaderCtrl
 # Controller of the frontApp
###
angular.module "frontApp"
  .controller "HeaderCtrl", ($scope, $rootScope, $timeout, $ionicSideMenuDelegate, $ionicModal, $ionicPopup, $sessionStorage, $location, $ionicHistory, $ionicNavBarDelegate, Api, toaster, Const) ->

    # 変数設定
    $scope.input =
      keywords: null

    $ionicModal.fromTemplateUrl('views/parts/modal-login.html',
      scope: $scope
      animation: 'slide-in-up').then (modalLogin) ->
      $scope.modalLogin = modalLogin

    $ionicModal.fromTemplateUrl('views/parts/modal-search.html',
      scope: $scope
      animation: 'scale-in'
      backdropClickToClose: false).then (modalSearch) ->
        $scope.modalSearch = modalSearch

    if !$sessionStorage['token']
      $rootScope.isLogin = false
    else
      $rootScope.isLogin = true
    $scope.showLogin = false
    if $location.search()["showLogin"]
      $scope.showLogin = true

    # 初期処理
    clearInput = ->
      input =
        email: ""
        password: ""
        password_confirmation: ""
      $scope.input = input

    clearInput()

    if $sessionStorage['email']
      $scope.input.email = $sessionStorage['email']

    # Function
    $scope.openModalLogin = ->
      $scope.modalLogin.show()

    $scope.hideModalLogin = ->
      $scope.modalLogin.hide()

    $scope.toggleRight = ->
      $ionicSideMenuDelegate.toggleRight();

    $scope.doLogin = ->
      obj =
        "user[email]": $scope.input.email
        "user[password]": $scope.input.password

      Api.postJson(obj, Const.API.LOGIN).then (res) ->
        $ionicSideMenuDelegate.toggleRight();
        $scope.modalLogin.hide()
        clearInput()

        $sessionStorage['email'] = res.data.email
        $sessionStorage['token'] = res.data.authentication_token
        $sessionStorage['user_id'] = res.data.id
        $rootScope.isLogin = true
        # toast表示
        toaster.pop
          type: 'success',
          title: Const.MSG.LOGED_IN,
          showCloseButton: true

    $scope.doLogout = ->
      $ionicPopup.show(
        title: 'ログアウトしてよろしいですか？'
        scope: $scope
        buttons: [
          { text: 'キャンセル' }
          {
            text: '<b>OK</b>'
            type: 'button-dark'
            onTap: (e) ->
              $rootScope.isLogin = false
              accessKey =
                email: $sessionStorage['email']
                token: $sessionStorage['token']

              Api.logOut(accessKey, Const.API.LOGOUT).then (res) ->
                $ionicSideMenuDelegate.toggleRight();
                clearInput()
                # login情報の削除
                delete $sessionStorage['token']
                delete $sessionStorage['email']
                delete $sessionStorage['user_id']
                clearInput()
                $location.path('/home/');
          }
        ])

    $scope.doSignUp = ->
      obj =
        "user[email]": $scope.input.email
        "user[password]": $scope.input.password
        "user[password_confirmation]": $scope.input.password_confirmation

      Api.saveJson(obj, Const.API.USER, Const.METHOD.POST).then (res) ->
        $scope.doLogin()
        $scope.modalLogin.hide()
        clearInput()
        # toast表示
        toaster.pop
          type: 'success',
          title: Const.MSG.SINGED_UP,
          showCloseButton: true

    $scope.closeMenu = ->
      $ionicSideMenuDelegate.toggleRight();

    $scope.moveToWriterDetail = ->
      userId = $sessionStorage['user_id']
      $location.path('/writer/' + userId);
      $ionicSideMenuDelegate.toggleRight();

    clearForMove = ->
      # backボタンを隠す
      $ionicNavBarDelegate.showBackButton false
      # historyデータを削除する
      $ionicHistory.clearHistory();
      $ionicHistory.clearCache();
      $ionicSideMenuDelegate.toggleRight();

    $scope.moveToHome = ->
      $location.path('/home');
      clearForMove()

    $scope.moveToShops = ->
      $location.path('/shops');
      clearForMove()

    $scope.moveToMap = ->
      $location.path('/map');
      clearForMove()

    $scope.goBack = ->
      $rootScope.isHideTab = false
      $ionicHistory.goBack();

    $scope.openModalSearch = ->
      # 検索ワードの取得
      $scope.input.keywords = $location.search()['keywords']

      # 現在Pathの取得
      currentPath = $location.path();
      if currentPath == '/shops'
        $scope.currentType = 'shop'
      else
        $scope.currentType = 'post'

      if !$scope.shopCategories || !$scope.postCategories
        # ShopCategoryを取得する
        shopCategoryObj =
          type: "ShopCategory"
        Api.getJson(shopCategoryObj, Const.API.CATEGORY, true).then (res) ->
          $scope.shopCategories = res.data

        # PostCategoryを取得する
        postCategoryObj =
          type: "PostCategory"
        Api.getJson(postCategoryObj, Const.API.CATEGORY, true).then (res) ->
          $scope.postCategories = res.data

      $scope.modalSearch.show()

    $scope.hideModalSearch = ->
      $scope.modalSearch.hide()

    $scope.selectPostCategory = (type) ->
      if $scope.currentType == type
        $scope.currentType = null
      else
        $scope.currentType = type

    $scope.selectSearchCategory = (id) ->
      if $scope.selectedId == id
        $scope.selectedId = null
      else
        $scope.selectedId = id

    $scope.submitSearch = ->
      if !$scope.input.keywords
        $scope.input.keywords = null
      if $scope.currentType == 'shop'
        $location.path('/shops').search('keywords', $scope.input.keywords)
        if $rootScope.shopsSearch
          $rootScope.shopsSearch($scope.selectedId)
      else
        $location.path('/home').search('keywords', $scope.input.keywords)
        if $rootScope.postsSearch
          $rootScope.postsSearch($scope.selectedId)
      $scope.modalSearch.hide()
