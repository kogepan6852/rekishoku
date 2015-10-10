'use strict'

###*
 # @ngdoc function
 # @name frontApp.controller:PostListCtrl
 # @description
 # # PostListCtrl
 # Controller of the frontApp
###
angular.module "frontApp"
  .controller "PostListCtrl", ($scope, $rootScope, $ionicSideMenuDelegate, $ionicModal, $ionicSlideBoxDelegate, $sessionStorage, Api, Const, toaster) ->

    # 変数設定
    $ionicModal.fromTemplateUrl('views/modal-post.html',
      scope: $scope
      animation: 'slide-in-up').then (modal) ->
      $scope.modal = modal
      return

    $scope.categories = [
      {slug:'episode', name:'歴食エピソード'},
      {slug:'experience', name:'歴食体験'},
      {slug:'information', name:'歴食ニュース'}
    ]

    $scope.isShowBackSlide = false
    $scope.isShowAddPostDetail = true;
    $scope.slideLists = [1, 2, 3]

    # 初期処理
    clearInput = ->
      input =
        title: ""
        content: ""
        quotationUrl: ""
        quotationName: ""
        details: [{ id: 1 },{ id: 2 },{ id: 3 }]
        category: $scope.categories[0]
        authentication_token: $sessionStorage['token']
      $scope.input = input
      # 画像を削除する
      angular.forEach angular.element("input[type='file']"), (inputElem) ->
        angular.element(inputElem).val null

    clearInput()

    accessKey =
      email: $sessionStorage['email']
      token: $sessionStorage['token']

    $rootScope.postListInit = ->
      $scope.results = ""
      # post取得
      if ($sessionStorage['token'])
        Api.getJson(accessKey, Const.API.POST).then (res) ->
          $scope.results = res.data

    # Function
    $scope.openModal = ->
      $scope.modal.show()

    $scope.closeModal = (targetForm) ->
      targetForm.$setPristine()
      clearInput()
      $scope.modal.hide()

    $scope.editting = false

    $scope.doPost = (targetForm) ->
      # formdata
      fd = new FormData
      fdDetails = new FormData
      fd.append 'token', $sessionStorage['token']
      fd.append 'email', $sessionStorage['email']
      fd.append 'slug', $scope.input.category.slug
      fd.append 'post[title]', $scope.input.title
      fd.append 'post[image]', $scope.input.file
      fd.append 'post[content]', $scope.input.content
      fd.append 'post[quotation_url]', $scope.input.quotationUrl
      fd.append 'post[quotation_name]', $scope.input.quotationName

      # データ登録
      Api.saveFormData(fd, Const.API.POST, "").then (res) ->
        $scope.results.push res.data

        angular.forEach $scope.input.details, (detail, i) ->
          if detail.subTitle || detail.subFile || detail.subContent
            fdDetail = new FormData
            fdDetails.append 'post_details[][post_id]', res.data.id
            fdDetails.append 'post_details[][title]', detail.subTitle
            fdDetails.append 'post_details[][image]', detail.subFile
            fdDetails.append 'post_details[][content]', detail.subContent
            fdDetails.append 'post_details[][quotation_url]', detail.subQuotationUrl
            fdDetails.append 'post_details[][quotation_name]', detail.subQuotationName

        # 詳細データ登録
        Api.saveFormData(fdDetails, Const.API.POST_DETSIL, Const.MSG.SAVED).then (res) ->
          clearInput()
          targetForm.$setPristine()
          $scope.modal.hide()


    $scope.doDelete = (index) ->
      accessKey =
        email: $sessionStorage['email']
        token: $sessionStorage['token']
      targetPostId = $scope.results[index].id

      Api.deleteJson(accessKey, targetPostId, Const.API.POST).then (res) ->
        $scope.results.splice index, 1
        Api.deleteJson(accessKey, targetPostId, Const.API.POST_DETSIL).then (res) ->
          toaster.pop
            type: 'success',
            title: Const.MSG.DELETED,
            showCloseButton: true

    $scope.new = ->
      location.href = '#/post'

    $scope.edit = ->
      $scope.editting = !$scope.editting

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

    # 変化を監視してサブ画像1を読み込み＋表示を実行
    $scope.$watch 'input.details[0].subFile', (file) ->
      watchSubFile(0, file)

    # 変化を監視してサブ画像2を読み込み＋表示を実行
    $scope.$watch 'input.details[1].subFile', (file) ->
      watchSubFile(1, file)

    # 変化を監視してサブ画像3を読み込み＋表示を実行
    $scope.$watch 'input.details[2].subFile', (file) ->
      watchSubFile(2, file)

    # 画像監視共通処理
    watchSubFile = (index, file) ->
      $scope.input.details[index].srcSubUrl = undefined
      #画像ファイルじゃなければ何もしない
      if !file or !file.type.match('image.*')
        return
      reader = new FileReader
      reader.onload = ->
        $scope.$apply ->
          $scope.input.details[index].srcSubUrl = reader.result
      reader.readAsDataURL file

    $scope.prevSlide = ->
      $ionicSlideBoxDelegate.next()
      $scope.isShowBackSlide = true
      if $ionicSlideBoxDelegate.currentIndex() >= 3
        $scope.isShowAddPostDetail = false

    $scope.backSlide =->
      $ionicSlideBoxDelegate.previous()
      $scope.isShowAddPostDetail = true
      if $ionicSlideBoxDelegate.currentIndex() == 0
        $scope.isShowBackSlide = false
