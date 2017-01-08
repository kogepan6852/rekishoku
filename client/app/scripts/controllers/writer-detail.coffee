'use strict'

###*
 # @ngdoc function
 # @name frontApp.controller:WriterDetailCtrl
 # @description
 # WritersCtrl
 # Controller of the frontApp
###
angular.module "frontApp"
  .controller "WriterDetailCtrl", ($scope, $rootScope, $stateParams, $ionicModal, $localStorage, $controller, $state, Api, Const, toaster, $translate, $window, $ionicSlideBoxDelegate, $ionicNavBarDelegate, $ionicScrollDelegate) ->

    # Controllerの継承
    $controller 'BaseCtrl', $scope: $scope

    ###
    # setting
    ###
    $rootScope.isHideTab = true
    $ionicModal.fromTemplateUrl('views/parts/modal-profile-edit.html',
      scope: $scope
      animation: 'slide-in-up').then (modalProfileEdit) ->
      $scope.modalProfileEdit = modalProfileEdit
    $scope.isLoginUser = false
    $scope.activeSlideNo = 0

    # 画面表示ごとの初期処理
    $scope.$on '$ionicView.beforeEnter', (e) ->
      $window.prerenderReady = false;
      if $scope.user
        setSeo()

    ###
    # common function
    ###
    setSeo = ->
      appKeywords = []
      appKeywords.push($translate.instant('SEO.KEYWORDS.BASE'))
      appKeywords.push($scope.user.username)
      $rootScope.appTitle = $translate.instant('SEO.TITLE.BASE') + $scope.user.username
      $rootScope.appDescription = $scope.user.profile.substr(0, 150)
      $rootScope.appImage = $scope.user.image.md.url
      $rootScope.appKeywords = appKeywords.join()

      # Prerender.io
      $scope.readyToCache(1000)

    ###
    # Common function
    ###
    clearInput = ->
      input =
        email: ""
        password: ""
        password_confirmation: ""
      $scope.input = input
      # 画像を削除する
      angular.forEach angular.element("input[type='file']"), (inputElem) ->
        angular.element(inputElem).val null

    ###
    # initialize
    ###
    $scope.init = ->
      clearInput()
      accessKey =
        email: $localStorage['email']
        token: $localStorage['token']
      path = Const.API.USER + '/' + $stateParams.id
      Api.getJson(accessKey, path, false).then (res) ->
        $scope.user = res.data

        # SEO
        setSeo()

        $ionicScrollDelegate.$getByHandle('writerDetailScroll').resize()

      obj =
        writer: $stateParams.id
      # 記事一覧取得
      Api.getJson(obj, Const.API.POST, false).then (res) ->
        $scope.posts = res.data
      # 特集一覧取得
      Api.getJson(obj, Const.API.FEATURE, false).then (res) ->
        $scope.features = res.data


      if String($stateParams.id) == String($localStorage['user_id'])
        $scope.isLoginUser = true


    ###
    # function
    ###
    $scope.openModalProfileEdit = ->
      $scope.input =
        email: $scope.user.email
        username: $scope.user.username
        first_name: $scope.user.first_name
        last_name: $scope.user.last_name
        profile: $scope.user.profile
        image: $scope.user.image
      $scope.srcUrl = $scope.user.image.thumb.url
      $scope.modalProfileEdit.show()

    $scope.hideModalProfileEdit = (targetForm) ->
      clearInput()
      targetForm.$setPristine()
      $scope.modalProfileEdit.hide()

    $scope.saveProfile = (targetForm) ->
        fd = new FormData
        userId = $localStorage['user_id']
        fd.append 'token', $localStorage['token']
        fd.append 'email', $localStorage['email']
        fd.append 'user[id]', userId
        fd.append 'user[username]', $scope.input.username.trim()
        fd.append 'user[last_name]', $scope.input.last_name.trim()
        fd.append 'user[first_name]', $scope.input.first_name.trim()
        fd.append 'user[profile]', $scope.input.profile.trim()
        fd.append 'user[image]', $scope.input.file
        if $scope.input.file then fd.append 'user[image]', $scope.input.file

        # データ登録
        url = Const.API.USER+'/'+userId
        method = Const.METHOD.PATCH

        Api.saveFormData(fd, url, method).then (res) ->
          clearInput()
          targetForm.$setPristine()
          $scope.modalProfileEdit.hide()
          toaster.pop
            type: 'success',
            title: $translate.instant('MSG.INFO.SAVED_PROFILE'),
            showCloseButton: true

          $scope.init()

    # 変化を監視してメイン画像を読み込み＋表示を実行
    $scope.$watch 'input.file', (file) ->
      $scope.srcUrl = undefined
      #画像ファイルじゃなければ何もしない
      if !file or !file.type.match('image.*')
        return
      reader = new FileReader
      reader.onload = ->
        $scope.$apply ->
          $scope.srcUrl = reader.result
      reader.readAsDataURL file

    $scope.moveToPostDetail = (id) ->
      $ionicNavBarDelegate.showBackButton true
      $state.go('postDetail', { id: id })

    # ショップ詳細移動時の処理
    $scope.moveToFeatureDetail = (id) ->
      $ionicNavBarDelegate.showBackButton true
      $state.go 'featureDetal', {id:id}

    $scope.clickTab = (targetSlide) ->
      $scope.activeSlideNo = targetSlide
      $ionicSlideBoxDelegate.$getByHandle('writer-list').slide(targetSlide)

    $scope.disableSwipe = ->
      $ionicSlideBoxDelegate.enableSlide(false);
