'use strict'

###*
 # @ngdoc function
 # @name frontApp.controller:HeaderCtrl
 # @description
 # # HeaderCtrl
 # Controller of the frontApp
###
angular.module "frontApp"
  .controller "HeaderCtrl", ($scope, $rootScope, $timeout, $ionicSideMenuDelegate, $ionicSlideBoxDelegate, $ionicScrollDelegate, $ionicModal, $ionicPopup, $localStorage, $location, $state, $ionicHistory, $ionicNavBarDelegate, $ionicViewSwitcher, $translate, $cookies, Api, toaster, Const, DataService) ->

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
      if currentPath.indexOf('/store/list') != -1
        $rootScope.currentType = 'shop'
      else if currentPath.indexOf('/store/map') != -1
        $rootScope.currentType = 'map'
      else
        $rootScope.currentType = 'home'

    clearForMove = ->
      # backボタンを隠す
      $ionicNavBarDelegate.showBackButton false
      # historyデータを削除する
      $ionicHistory.clearHistory();
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

    $scope.moveToHome = ->
      $ionicViewSwitcher.nextTransition('none')
      $state.go('tabs.magazine')
      $rootScope.currentType = 'magazine'
      clearForMove()

    $scope.moveToShops = ->
      $ionicViewSwitcher.nextTransition('none')
      $state.go('tabs.shops')
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
      if $ionicHistory.backTitle() == 'STORES'
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
        $location.path('/app/shops').search('keywords', $scope.input.keywords)
        if $rootScope.shopsSearch
          $rootScope.shopsSearch($scope.selectedId)
      else if $rootScope.currentType == 'map'
        $location.path('/app/map').search('keywords', $scope.input.keywords)
        if $rootScope.mapSearch
          $rootScope.mapSearch()
      else
        $location.path('/app').search('keywords', $scope.input.keywords)
        if $rootScope.postsSearch
          $rootScope.postsSearch($scope.selectedId)
      $scope.modalSearch.hide()

    # 時代の一覧取得
    $scope.openPeriods = ->
      $scope.menuItems = null
      $scope.menuTarget = 'period'
      $ionicSlideBoxDelegate.next()
      $ionicScrollDelegate.$getByHandle('list-slide').scrollTop();
      if $scope.periods
        return

      DataService.getPeriod (data) ->
        $scope.menuItems = data

    # 人物の一覧取得
    $scope.openPeople = ->
      $scope.menuItems = null
      $scope.menuTarget = 'person'
      $ionicSlideBoxDelegate.next()
      $ionicScrollDelegate.$getByHandle('list-slide').scrollTop();
      if $scope.people
        return

      DataService.getPeople (data) ->
        $scope.menuItems = data

    $scope.backSlide = ->
      $ionicSlideBoxDelegate.previous()

    $scope.disableSwipe = ->
      $ionicSlideBoxDelegate.enableSlide(false);

    $scope.searchByPeriods = (id, target) ->
      # shop検索
      if $rootScope.currentType == 'shop'
        $location.path('/app/store/list').search(target, id)
        if $rootScope.shopsSearch
          $rootScope.shopsSearch($scope.selectedId)
      # map検索
      else if $rootScope.currentType == 'map'
        $location.path('/app/store/map').search(target, id)
        if $rootScope.mapSearch
          $rootScope.mapSearch($scope.selectedId)
      # post検索
      else
        $rootScope.currentType = 'home'
        $location.path('/app/magazine').search(target, id)
        if $rootScope.postsSearch
          $rootScope.postsSearch($scope.selectedId)

      $ionicSlideBoxDelegate.previous()
      $ionicSideMenuDelegate.toggleRight(false);
