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
      animation: 'slide-in-up'
      backdropClickToClose: false).then (modal) ->
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
    $scope.showDeleteButton = false

    # 初期処理
    clearInput = ->
      # post detailの初期化
      details = []
      for slideList in $scope.slideLists
        detail =
          id: slideList
          subTitle: null
          subContent: null
          subQuotationUrl: null
          subQuotationName: null
        details.push(detail)
      # postの初期化
      input =
        title: null
        content: null
        quotationUrl: null
        quotationName: null
        details: details
        category: $scope.categories[0]
        authentication_token: $sessionStorage['token']
      $scope.input = input
      # 画像を削除する
      angular.forEach angular.element("input[type='file']"), (inputElem) ->
        angular.element(inputElem).val null
      # slideを一番前に移動
      $ionicSlideBoxDelegate.slide(0)
      $scope.isShowBackSlide = false
      $scope.isShowAddPostDetail = true
      # 削除ボタンを非表示
      $scope.showDeleteButton = false

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
      # formdata作成
      fd = new FormData
      fdDetails = new FormData
      fd.append 'token', $sessionStorage['token']
      fd.append 'email', $sessionStorage['email']
      fd.append 'slug', $scope.input.category.slug
      fd.append 'post[title]', $scope.input.title.trim()
      fd.append 'post[image]', $scope.input.file
      if $scope.input.content then fd.append 'post[content]', $scope.input.content
      if $scope.input.quotationUrl then fd.append 'post[quotation_url]', $scope.input.quotationUrl
      if $scope.input.quotationName then fd.append 'post[quotation_name]', $scope.input.quotationName

      # データ登録
      Api.saveFormData(fd, Const.API.POST, "").then (res) ->
        # 初期化処理実行
        $rootScope.postListInit()

        angular.forEach $scope.input.details, (detail, i) ->
          if detail.subTitle || detail.subFile || detail.subContent
            # formdata作成
            fdDetail = new FormData
            fdDetails.append 'post_details[][post_id]', res.data.id
            if detail.subTitle then fdDetails.append 'post_details[][title]', detail.subTitle.trim()
            if detail.subFile then fdDetails.append 'post_details[][image]', detail.subFile
            if detail.subContent then fdDetails.append 'post_details[][content]', detail.subContent
            if detail.subQuotationUrl then fdDetails.append 'post_details[][quotation_url]', detail.subQuotationUrl
            if detail.subQuotationName then fdDetails.append 'post_details[][quotation_name]', detail.subQuotationName

        # 詳細データ登録
        Api.saveFormData(fdDetails, Const.API.POST_DETSIL, Const.MSG.SAVED).then (res) ->
          clearInput()
          targetForm.$setPristine()
          $scope.modal.hide()

    $scope.doDelete = ->
      $scope.showDeleteButton = false
      # login情報
      accessKey =
        email: $sessionStorage['email']
        token: $sessionStorage['token']
      # 削除数
      deleteCount = 0
      angular.forEach $scope.results, (result, index) ->
        if result.checked
          targetPostId = result.id
          # データ削除
          Api.deleteJson(accessKey, targetPostId, Const.API.POST).then (res) ->
            $scope.results.splice (index - deleteCount), 1
            deleteCount += 1;
            # 詳細データ削除
            Api.deleteJson(accessKey, targetPostId, Const.API.POST_DETSIL).then (res) ->

    $scope.onEditButton = (index) ->
      Api.getJson("", Const.API.POST_DETSIL + '/' + $scope.results[index].id).then (res) ->
        console.log(res.data)
        # post detailの作成
        details = []
        angular.forEach $scope.slideLists, (slideList, i) ->
          detail =
            id: slideList
            subTitle: if res.data[i] then res.data[i].title else null
            subContent:  if res.data[i] then res.data[i].content else null
            subQuotationUrl:  if res.data[i] then res.data[i].quotation_url else null
            subQuotationName:  if res.data[i] then res.data[i].quotation_name else null
          details.push(detail)
        # postの作成
        $scope.input =
          title: $scope.results[index].title
          content: $scope.results[index].content
          quotationUrl: $scope.results[index].quotationUrl
          quotationName: $scope.results[index].quotationName
          details: details
          category: $scope.results[index].category
        $scope.modal.show()


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

    $scope.backSlide = ->
      $ionicSlideBoxDelegate.previous()
      $scope.isShowAddPostDetail = true
      if $ionicSlideBoxDelegate.currentIndex() == 0
        $scope.isShowBackSlide = false

    $scope.onCheckbox = (result) ->
      if !result.checked
        result.checked = true
        $scope.showDeleteButton = true
      else
        result.checked = false
        isChecked = false
        angular.forEach $scope.results, (result, key) ->
          if result.checked
            isChecked = true
        if !isChecked
          $scope.showDeleteButton = false
