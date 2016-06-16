'use strict'

###*
 # @ngdoc function
 # @name frontApp.controller:HeaderCtrl
 # @description
 # # HeaderCtrl
 # Controller of the frontApp
###
angular.module "frontApp"
  .controller "HeaderCtrl", ($scope, $rootScope, $timeout, $ionicSideMenuDelegate, $ionicSlideBoxDelegate, $ionicScrollDelegate, $ionicModal, $ionicPopup, $localStorage, $location, $state, $ionicHistory, $ionicNavBarDelegate, $ionicViewSwitcher, $translate, $cookies, Api, toaster, Const, DataService, HeaderService) ->

    ###
    # setting
    ###
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

    ###
    # initialize
    ###
    $scope.init = ->
      clearInput()
      # 現在Pathの取得
      setCurrentType()
      $ionicSlideBoxDelegate.enableSlide(false);

    ###
    # Common function
    ###
    clearInput = ->
      input =
        email: ""
        password: ""
        password_confirmation: ""
      $scope.input = input

    # 現在Pathの取得
    setCurrentType = ->
      currentPath = $location.path();
      if currentPath.indexOf('/shop/list') != -1
        $rootScope.currentType = 'shop'
      else if currentPath.indexOf('/shop/map') != -1
        $rootScope.currentType = 'map'
      else
        $rootScope.currentType = 'magazine'

    clearForMove = ->
      # backボタンを隠す
      $ionicNavBarDelegate.showBackButton false
      # historyデータを削除する
      $ionicHistory.clearHistory();
      $ionicHistory.clearCache();
      $ionicSideMenuDelegate.toggleRight(false);

    ###
    # Function
    ###
    $scope.openModalLogin = ->
      $scope.modalLogin.show()

    $scope.hideModalLogin = ->
      $scope.modalLogin.hide()

    $scope.toggleRight = ->
      $ionicSideMenuDelegate.toggleRight();

    $scope.toggleLeft = ->
      $ionicSideMenuDelegate.toggleLeft();

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
      $state.go('writer', { id: userId })
      clearForMove()

    $scope.moveToHome = ->
      $ionicViewSwitcher.nextTransition('none')
      $state.go('tabs.magazine')
      $rootScope.currentType = 'magazine'
      clearForMove()

    $scope.moveToShops = ->
      $ionicViewSwitcher.nextTransition('none')
      $state.go('tabs.shop.list')
      $rootScope.currentType = 'shop'
      clearForMove()

    $scope.moveToMap = ->
      $ionicViewSwitcher.nextTransition('none')
      $state.go('tabs.map')
      $rootScope.currentType = 'map'
      clearForMove()

    $scope.moveToWriters = ->
      $ionicViewSwitcher.nextTransition('none')
      $state.go('writers')
      $rootScope.currentType = 'writers'
      clearForMove()

    $scope.moveToMyPost = ->
      $ionicViewSwitcher.nextTransition('none')
      $state.go('my-post')
      $rootScope.currentType = 'myPost'
      clearForMove()

    $scope.goBack = ->
      $rootScope.isHideTab = false
      $ionicHistory.goBack();
      # STORESに戻る場合、フッターを戻す
      if $ionicHistory.backTitle() == 'SHOPS' || $ionicHistory.backTitle() == 'MAGAZINE'
        $rootScope.hideFooter = false
        $rootScope.hideModeBtn = false
        $ionicNavBarDelegate.showBackButton false

    $scope.openModalSearch = ->
      # 検索ワードの取得
      $scope.input.keywords = $location.search()['keywords']

      # 現在Pathの取得
      setCurrentType()

      if !$scope.shopCategories || !$scope.postCategories
        # PostCategoryを取得する
        DataService.getPostCategory (data) ->
          $scope.postCategories = data
        # ShopCategoryを取得する
        DataService.getShopCategory (data) ->
          $scope.shopCategories = data

      $scope.modalSearch.show()

    $scope.hideModalSearch = ->
      $scope.modalSearch.hide()
      setCurrentType()

    $scope.selectPostCategory = (type) ->
      if $rootScope.currentType == type
        $rootScope.currentType = null
      else
        $rootScope.currentType = type

    $scope.selectSearchCategory = (id) ->
      if $scope.selectedId == id
        $scope.selectedId = null
      else
        $scope.selectedId = id

    $scope.submitSearch = ->
      if !$scope.input.keywords
        $scope.input.keywords = null
      if $rootScope.currentType == 'shop'
        $location.path('/app/shop/list').search('keywords', $scope.input.keywords)
        if $rootScope.shopsSearch
          $rootScope.shopsSearch()
        $ionicScrollDelegate.$getByHandle('shops').scrollTop();

      else if $rootScope.currentType == 'map'
        $location.path('/app/shop/map').search('keywords', $scope.input.keywords)
        if $rootScope.mapSearch
          $rootScope.mapSearch()

      else
        $location.path('/app/magazine').search('keywords', $scope.input.keywords)
        if $rootScope.postsSearch
          $rootScope.postsSearch()
        $ionicScrollDelegate.$getByHandle('magazine').scrollTop();

      # $scope.modalSearch.hide()
      $ionicSideMenuDelegate.toggleLeft(false);

    # 時代一覧の取得
    $scope.openPeriods = (handle) ->
      $scope.showNextSlide = false;
      $scope.menuItems = null
      $scope.menuTarget = 'period'
      $ionicSlideBoxDelegate.$getByHandle(handle).next()
      $ionicScrollDelegate.$getByHandle('list-slide').scrollTop();

      DataService.getPeriod (data) ->
        $scope.menuItems = data


    # 人物カテゴリ一覧の取得
    $scope.openPeopleCategory = (handle) ->
      $scope.showNextSlide = true;
      $scope.menuItems = null
      $scope.menuTarget = 'person'
      $ionicSlideBoxDelegate.$getByHandle(handle).next()
      $ionicScrollDelegate.$getByHandle('list-slide').scrollTop();

      DataService.getPeopleCategory (data) ->
        $scope.menuItems = data

    # 人物一覧の取得
    $scope.openPeople = (handle, id) ->
      $scope.showNextSlide = false;
      $scope.menuSubItems = null
      $scope.menuTarget = 'person'
      $ionicSlideBoxDelegate.$getByHandle(handle).next()
      $ionicScrollDelegate.$getByHandle('list-slide').scrollTop();

      DataService.getPeople ((data) ->
        $scope.menuSubItems = data
      ), id

    # カテゴリー一覧の取得
    $scope.openCategories = (handle) ->
      $scope.showNextSlide = false;
      $scope.menuItems = null
      $scope.menuTarget = 'category'
      $ionicSlideBoxDelegate.$getByHandle(handle).next()
      $ionicScrollDelegate.$getByHandle('list-slide').scrollTop();

      if $rootScope.currentType == 'magazine'
        # PostCategoryを取得する
        DataService.getPostCategory (data) ->
          $scope.menuItems = data
      else
        # ShopCategoryを取得する
        DataService.getShopCategory (data) ->
          $scope.menuItems = data

    # 都道府県エリアの取得
    $scope.openProvincesArea = (handle) ->
      $scope.showNextSlide = true;
      $scope.menuItems = null
      $scope.menuTarget = 'province'
      $ionicSlideBoxDelegate.$getByHandle(handle).next()
      $ionicScrollDelegate.$getByHandle('list-slide').scrollTop()

      # 検索用にオブジェクト生成
      $scope.menuItems = HeaderService.getProvincesArea()

    # 都道府県一覧の取得
    $scope.openProvinces = (handle, index) ->
      $scope.showNextSlide = false;
      $scope.menuSubItems = null
      $scope.menuTarget = 'province'
      $ionicSlideBoxDelegate.$getByHandle(handle).next()
      $ionicScrollDelegate.$getByHandle('list-slide').scrollTop()

      # 検索用にオブジェクト生成
      $scope.menuSubItems = HeaderService.getProvinces(index)

    $scope.backSlide = (handle) ->
      $ionicSlideBoxDelegate.$getByHandle(handle).previous()
      $scope.showNextSlide = true;

    $scope.disableSwipe = ->
      $ionicSlideBoxDelegate.enableSlide(false);

    $scope.searchByConditions = (id, target) ->
      HeaderService.searchByConditions(id, target)
