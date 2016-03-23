'use strict'

###*
 # @ngdoc function
 # @name frontApp.controller:HeaderCtrl
 # @description
 # # HeaderCtrl
 # Controller of the frontApp
###
angular.module "frontApp"
  .controller "HeaderCtrl", ($scope, $rootScope, $timeout, $ionicSideMenuDelegate, $ionicModal, $ionicPopup, $localStorage, $location, $state, $ionicHistory, $ionicNavBarDelegate, $ionicViewSwitcher, $translate, $cookies, Api, toaster, Const) ->

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

    # 初期処理
    clearInput = ->
      input =
        email: ""
        password: ""
        password_confirmation: ""
      $scope.input = input

    clearInput()

    # cookieより値を取得
    $localStorage['email'] = $cookies.get 'email'
    if $localStorage['email']
      $scope.input.email = $localStorage['email']
    else
      # login情報の削除
      delete $localStorage['token']
      delete $localStorage['email']
      delete $localStorage['user_id']

    if !$localStorage['token']
      $rootScope.isLogin = false
    else
      $rootScope.isLogin = true
    $scope.showLogin = false
    if $location.search()["showLogin"] || $localStorage['email']
      $scope.showLogin = true

    # Function
    $scope.openModalLogin = ->
      $scope.modalLogin.show()

    $scope.hideModalLogin = ->
      $scope.modalLogin.hide()

    $scope.toggleRight = ->
      $ionicSideMenuDelegate.toggleRight();

    $scope.doLogin = ->
      # cookieの設定
      expire = new Date
      expire.setMonth expire.getMonth() + 1
      $cookies.put 'email', $scope.input.email, expires: expire

      obj =
        "user[email]": $scope.input.email
        "user[password]": $scope.input.password

      Api.postJson(obj, Const.API.LOGIN).then (res) ->
        $ionicSideMenuDelegate.toggleRight();
        $scope.modalLogin.hide()
        clearInput()

        $localStorage['email'] = res.data.email
        $localStorage['token'] = res.data.authentication_token
        $localStorage['user_id'] = res.data.id
        $rootScope.isLogin = true
        # toast表示
        toaster.pop
          type: 'success',
          title: $translate.instant('MSG.INFO.LOGED_IN'),
          showCloseButton: true

    $scope.doLogout = ->
      $ionicPopup.show(
        title: $translate.instant('MSG.COMFIRM.LOGOUT')
        scope: $scope
        buttons: [
          { text: $translate.instant('BUTTON.CANCEL') }
          {
            text: '<b>'+$translate.instant('BUTTON.OK')+'</b>'
            type: 'button-dark'
            onTap: (e) ->
              $rootScope.isLogin = false
              accessKey =
                email: $localStorage['email']
                token: $localStorage['token']

              Api.logOut(accessKey, Const.API.LOGOUT).then (res) ->
                $ionicSideMenuDelegate.toggleRight();
                clearInput()
                # login情報の削除
                delete $localStorage['token']
                delete $localStorage['email']
                delete $localStorage['user_id']
                # cookieの削除
                $cookies.remove 'email'

                clearInput()
                $location.path('/app');
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
          title: $translate.instant('MSG.INFO.SINGED_UP'),
          showCloseButton: true

    $scope.closeMenu = ->
      $ionicSideMenuDelegate.toggleRight();

    $scope.moveToWriterDetail = ->
      $ionicViewSwitcher.nextTransition('none')
      userId = $localStorage['user_id']
      $state.go('tabs.post-writer', { id: userId })
      clearForMove()

    clearForMove = ->
      # backボタンを隠す
      $ionicNavBarDelegate.showBackButton false
      # historyデータを削除する
      $ionicHistory.clearHistory();
      $ionicHistory.clearCache();
      $ionicSideMenuDelegate.toggleRight(false);

    $scope.moveToHome = ->
      $ionicViewSwitcher.nextTransition('none')
      $state.go('tabs.home')
      clearForMove()

    $scope.moveToShops = ->
      $ionicViewSwitcher.nextTransition('none')
      $state.go('tabs.shops')
      clearForMove()

    $scope.moveToMap = ->
      $ionicViewSwitcher.nextTransition('none')
      $state.go('tabs.map')
      clearForMove()

    $scope.moveToWriters = ->
      $ionicViewSwitcher.nextTransition('none')
      $state.go('writers')
      clearForMove()

    $scope.moveToMyPost = ->
      $ionicViewSwitcher.nextTransition('none')
      $state.go('my-post')
      clearForMove()

    $scope.goBack = ->
      $rootScope.isHideTab = false
      $ionicHistory.goBack();

    $scope.openModalSearch = ->
      # 検索ワードの取得
      $scope.input.keywords = $location.search()['keywords']

      # 現在Pathの取得
      currentPath = $location.path();
      if currentPath == '/app/shops'
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
        $location.path('/app/shops').search('keywords', $scope.input.keywords)
        if $rootScope.shopsSearch
          $rootScope.shopsSearch($scope.selectedId)
      else
        $location.path('/app').search('keywords', $scope.input.keywords)
        if $rootScope.postsSearch
          $rootScope.postsSearch($scope.selectedId)
      $scope.modalSearch.hide()
