'use strict'

###*
 # @ngdoc function
 # @name frontApp.controller:PostListCtrl
 # @description
 # # PostListCtrl
 # Controller of the frontApp
###
angular.module "frontApp"
  .controller "PostListCtrl", ($scope, $rootScope, $ionicSideMenuDelegate, $ionicModal, $ionicPopover, $ionicPopup, $ionicSlideBoxDelegate, $localStorage, $controller, $translate, $state, Api, Const, toaster) ->

    # Controllerの継承
    $controller 'BaseCtrl', $scope: $scope

    # 変数設定
    $ionicModal.fromTemplateUrl('views/parts/modal-post.html',
      scope: $scope
      animation: 'slide-in-up'
      backdropClickToClose: false).then (modalPost) ->
        $scope.modalPost = modalPost

    $ionicModal.fromTemplateUrl('views/parts/modal-shops.html',
      scope: $scope
      animation: 'slide-in-up'
      backdropClickToClose: false).then (modalShops) ->
        $scope.modalShops = modalShops

    $ionicModal.fromTemplateUrl('views/parts/modal-people.html',
      scope: $scope
      animation: 'slide-in-up'
      backdropClickToClose: false).then (modalPeople) ->
        $scope.modalPeople = modalPeople

    $ionicPopover.fromTemplateUrl('views/parts/popover-post-menu.html',
      scope: $scope).then (popoverPostMenu) ->
        $scope.popoverPostMenu = popoverPostMenu

    $scope.categories = [{}]
    categoryObj =
      type: "PostCategory"
    Api.getJson(categoryObj, Const.API.CATEGORY, true).then (res) ->
      $scope.categories = res.data
      $scope.categories[0].checked = true

    $scope.isShowBackSlide = false
    $scope.isShowAddPostDetail = true;
    $scope.slideLists = [1, 2, 3, 4, 5, 6]
    $scope.showDeleteButton = false
    $scope.isEditing = false

    clearInput = ->
      # post detailの初期化
      details = []
      for slideList in $scope.slideLists
        detail =
          index: slideList
          subTitle: null
          subContent: null
          subQuotationUrl: null
          subQuotationName: null
          id: null
        details.push(detail)
      # postの初期化
      input =
        title: null
        content: null
        quotationUrl: null
        quotationName: null
        details: details
        category: $scope.categories[0]
        id: null
        authentication_token: $localStorage['token']
      $scope.input = input
      # categoryの初期化
      angular.forEach $scope.categories, (category, i) ->
        category.checked = false
      $scope.categories[0].checked = true

      # 画像を削除する
      angular.forEach angular.element("input[type='file']"), (inputElem) ->
        angular.element(inputElem).val null
      $scope.srcUrl = null;
      # slideを一番前に移動
      $ionicSlideBoxDelegate.$getByHandle('modal-post').slide(0)
      $scope.isShowBackSlide = false
      $scope.isShowAddPostDetail = true
      # 削除ボタンを非表示
      $scope.showDeleteButton = false

    clearInput()

    accessKey =
      email: $localStorage['email']
      token: $localStorage['token']

    # initialize
    $scope.init = ->
      $scope.results = ""
      # post取得
      if ($localStorage['token'])
        Api.getJson(accessKey, Const.API.POST_LIST, true).then (res) ->
          $scope.results = res.data
          $scope.$broadcast 'scroll.refreshComplete'

    # Function
    # 投稿用モーダル表示
    $scope.openModalPost = () ->
      clearInput()
      $scope.isEditing = false
      $scope.modalPost.show()

    # 投稿用モーダル非表示
    $scope.closeModalPost = (targetForm) ->
      targetForm.$setPristine()
      $scope.modalPost.hide()

    # 店舗一覧表示用モーダル表示
    $scope.openModalShops = () ->
      # 店舗一覧を取得する
      obj =
        post_id: $scope.targetPostId
      Api.getJson(obj, Const.API.SHOP_LIST , true).then (resShop) ->
        $scope.shops = resShop.data
        angular.forEach $scope.shops, (shop) ->
          shop.checked = shop.hasPost

      # モーダルを開く
      $scope.modalShops.show()
      $scope.popoverPostMenu.hide()

    # 店舗一覧表示用モーダル非表示
    $scope.closeModalShops = () ->
      $scope.modalShops.hide()

    # 人物一覧表示用モーダル表示
    $scope.openModalPeople = () ->
      # 人物一覧を取得する
      obj =
        post_id: $scope.targetPostId
      Api.getJson(obj, Const.API.PERSON_LIST, true).then (resPerson) ->
        $scope.people = resPerson.data
        angular.forEach $scope.people, (person) ->
          person.checked = person.hasPost

      # モーダルを開く
      $scope.modalPeople.show()
      $scope.popoverPostMenu.hide()

    # 人物一覧表示用モーダル表示
    $scope.closeModalPeople = () ->
      $scope.modalPeople.hide()

    # 編集メニューポップオーバー表示
    $scope.openPopoverPostMenu = ($event, $index) ->
      $scope.targetIndex = $index
      $scope.targetPostId = $scope.results[$index].id
      $scope.targetStatus = $scope.results[$index].status
      $scope.popoverPostMenu.show $event

    # 編集メニューポップオーバー非表示
    $scope.closePopoverPostMenu = ->
      $scope.popoverPostMenu.hide()

    # 記事投稿処理
    $scope.doPost = (targetForm) ->
      # titleとimageが入力されている場合のみ
      if $scope.input.title && $scope.srcUrl
        # caregoryの取得
        targetSlug = null
        angular.forEach $scope.categories, (category) ->
          if category.checked
            targetSlug = category.slug
        # formdata作成
        fd = new FormData
        fdDetails = new FormData
        fd.append 'token', $localStorage['token']
        fd.append 'email', $localStorage['email']
        fd.append 'post[is_eye_catch]', $scope.input.isEyeCatch
        if targetSlug then fd.append 'slug', targetSlug
        if $scope.input.title then fd.append 'post[title]', $scope.input.title.trim()
        if $scope.input.file then fd.append 'post[image]', $scope.input.file
        if $scope.input.content then fd.append 'post[content]', $scope.input.content
        if $scope.input.quotationUrl then fd.append 'post[quotation_url]', $scope.input.quotationUrl
        if $scope.input.quotationName then fd.append 'post[quotation_name]', $scope.input.quotationName

        # データ登録
        url = Const.API.POST
        method = Const.METHOD.POST
        msg = $translate.instant('MSG.INFO.POSTED')
        # 更新の場合、idを設定する
        if $scope.input.id
          url += "/" + $scope.input.id
          method = Const.METHOD.PATCH
          msg = $translate.instant('MSG.INFO.UPDATED')

        Api.saveFormData(fd, url, method).then (res) ->
          # 初期化処理実行
          $scope.init()
          detailCount = 0

          angular.forEach $scope.input.details, (detail, i) ->
            if detail.subTitle || detail.subFile || detail.subContent
              # formdata作成
              fdDetail = new FormData
              fdDetails.append 'token', $localStorage['token']
              fdDetails.append 'email', $localStorage['email']
              fdDetails.append 'post_details[][post_id]', res.data.id
              fdDetails.append 'post_details[][is_eye_catch]', detail.isEyeCatch
              if detail.subTitle then fdDetails.append 'post_details[][title]', detail.subTitle.trim()
              if detail.subFile then fdDetails.append 'post_details[][image]', detail.subFile
              if detail.subContent then fdDetails.append 'post_details[][content]', detail.subContent
              if detail.subQuotationUrl then fdDetails.append 'post_details[][quotation_url]', detail.subQuotationUrl
              if detail.subQuotationName then fdDetails.append 'post_details[][quotation_name]', detail.subQuotationName
              if detail.id then fdDetails.append 'post_details[][id]', detail.id

              detailCount += 1

          # 詳細データ登録
          if detailCount >0
            Api.saveFormData(fdDetails, Const.API.POST_DETSIL, Const.METHOD.POST).then (res) ->
              clearInput()
              targetForm.$setPristine()
              $scope.modalPost.hide()
              $scope.popoverPostMenu.hide()
              toaster.pop
                type: 'success',
                title: msg,
                showCloseButton: true

          else
            clearInput()
            targetForm.$setPristine()
            $scope.modalPost.hide()
            toaster.pop
              type: 'success',
              title: msg,
              showCloseButton: true

    # 記事削除処理
    $scope.doDelete = ->
      $ionicPopup.show(
        title: $translate.instant('MSG.COMFIRM.DELETE')
        scope: $scope
        buttons: [
          { text: $translate.instant('BUTTON.CANCEL') }
          {
            text: '<b>'+$translate.instant('BUTTON.OK')+'</b>'
            type: 'button-dark'
            onTap: (e) ->
              deletePosts()
          }
        ])

    deletePosts = ->
      $scope.showDeleteButton = false
      # login情報
      accessKey =
        email: $localStorage['email']
        token: $localStorage['token']
      # 削除数
      deleteCount = 0
      resultLength = 0;
      angular.forEach $scope.results, (result, index) ->
        if result.checked
          resultLength += 1

      angular.forEach $scope.results, (result, index) ->
        if result.checked
          targetPostId = result.id
          # データ削除
          Api.deleteJson(accessKey, targetPostId, Const.API.POST).then (res) ->
            $scope.results.splice (index - deleteCount), 1
            deleteCount += 1
            # 詳細データ削除
            Api.deleteJson(accessKey, targetPostId, Const.API.POST_DETSIL).then (res) ->
              if resultLength == deleteCount
                toaster.pop
                  type: 'success',
                  title: $translate.instant('MSG.INFO.DELETED'),
                  showCloseButton: true

    # 記事編集用モーダル表示
    $scope.onEditButton = (index) ->
      clearInput()
      $scope.isEditing = true
      Api.getJson("", Const.API.POST_DETSIL + '/' + $scope.results[index].id, true).then (res) ->
        # categoryの設定
        $scope.checkCategory($scope.results[index].category_id)
        # post detailの作成
        details = []
        angular.forEach $scope.slideLists, (slideList, i) ->
          detail =
            index: slideList
            subTitle: if res.data[i] then res.data[i].title else null
            subContent: if res.data[i] then res.data[i].content else null
            subQuotationUrl: if res.data[i] then res.data[i].quotation_url else null
            subQuotationName: if res.data[i] then res.data[i].quotation_name else null
            isEyeCatch: if res.data[i] then res.data[i].is_eye_catch else null
            srcSubUrl: if res.data[i] then res.data[i].image.thumb.url else null
            id: if res.data[i] then res.data[i].id else null
          details.push(detail)
        # postの作成
        $scope.input =
          title: $scope.results[index].title
          content: $scope.results[index].content
          quotationUrl: $scope.results[index].quotation_url
          quotationName: $scope.results[index].quotation_name
          isEyeCatch: $scope.results[index].is_eye_catch
          details: details
          category:
            name: $scope.results[index].category_name
            slug: $scope.results[index].category_slug
          id: $scope.results[index].id
        $scope.srcUrl = $scope.results[index].image.thumb.url
        # モーダルを開く
        $scope.modalPost.show()
        $scope.popoverPostMenu.hide()

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

    # 変化を監視してサブ画像4を読み込み＋表示を実行
    $scope.$watch 'input.details[3].subFile', (file) ->
      watchSubFile(3, file)

    # 変化を監視してサブ画像5を読み込み＋表示を実行
    $scope.$watch 'input.details[4].subFile', (file) ->
      watchSubFile(4, file)

    # 変化を監視してサブ画像6を読み込み＋表示を実行
    $scope.$watch 'input.details[5].subFile', (file) ->
      watchSubFile(5, file)

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

    # 記事編集用モーダル次へボタン
    $scope.prevSlide = ->
      $ionicSlideBoxDelegate.$getByHandle('modal-post').next()
      $scope.isShowBackSlide = true
      if $ionicSlideBoxDelegate.$getByHandle('modal-post').currentIndex() >= $scope.slideLists.length
        $scope.isShowAddPostDetail = false

    # 記事編集用モーダル前へボタン
    $scope.backSlide = ->
      $ionicSlideBoxDelegate.$getByHandle('modal-post').previous()
      $scope.isShowAddPostDetail = true
      if $ionicSlideBoxDelegate.$getByHandle('modal-post').currentIndex() == 0
        $scope.isShowBackSlide = false

    # リストチェック用
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

    # カテゴリチェック用
    $scope.checkCategory = (id) ->
      angular.forEach $scope.categories, (category, i) ->
        if id == category.id
          category.checked = true
          $scope.targetCategorySlug = category.slug
        else
          category.checked = false

    # 関連店舗の保存
    $scope.saveShops = ->
      shopIds = []
      angular.forEach $scope.shops, (shop) ->
        if shop.checked
          shopIds.push(shop.id)

      obj =
        email: $localStorage['email']
        token: $localStorage['token']
        post_id: $scope.targetPostId
        shop_ids: shopIds

      Api.saveJson(obj, Const.API.POSTS_SHOPS, Const.METHOD.POST).then (res) ->
        $scope.modalShops.hide()
        $scope.popoverPostMenu.hide()
        toaster.pop
          type: 'success',
          title: $translate.instant('MSG.INFO.SAVED'),
          showCloseButton: true

    # 関連人物の保存
    $scope.savePeople = ->
      personIds = []
      angular.forEach $scope.people, (person) ->
        if person.checked
          personIds.push(person.id)

      obj =
        email: $localStorage['email']
        token: $localStorage['token']
        post_id: $scope.targetPostId
        person_ids: personIds

      Api.saveJson(obj, Const.API.PEOPLE_POSTS, Const.METHOD.POST).then (res) ->
        $scope.modalPeople.hide()
        $scope.popoverPostMenu.hide()
        toaster.pop
          type: 'success',
          title: $translate.instant('MSG.INFO.SAVED'),
          showCloseButton: true

    # 記事詳細への遷移
    $scope.moveToPost = (index) ->
      $scope.popoverPostMenu.hide()
      $state.go('post', { id: $scope.results[index].id, preview: "true" })

    # 公開
    $scope.publish = (status, id) ->
      # 今日日付設定
      today = new Date()
      year = today.getFullYear()
      month = ("0"+(today.getMonth() + 1)).slice(-2)
      date = ("0"+today.getDate()).slice(-2)
      dispToday = year + '-' + month + '-' + date

      $scope.input =
        publishDate: dispToday
      updStatus = 1 - status;

      msg = $translate.instant('MSG.COMFIRM.PUBLISHE')
      subMsg = $translate.instant('MSG.COMFIRM.PUBLISHE_SUB')
      template = '<input type="text" ng-model="input.publishDate">'
      if updStatus == 0
        msg = $translate.instant('MSG.COMFIRM.UNPUBLISHE')
        subMsg = ''
        template = ''

      $ionicPopup.show(
        title: msg
        subTitle: subMsg
        template: template
        scope: $scope
        buttons: [
          { text: $translate.instant('BUTTON.CANCEL') }
          {
            text: '<b>'+$translate.instant('BUTTON.OK')+'</b>'
            type: 'button-dark'
            onTap: (e) ->
              if updStatus == 0 || $scope.input.publishDate
                updateStatus(updStatus, id, $scope.input.publishDate)
              else
                e.preventDefault()
          }
        ])

    # ステータスのアップデート処理
    updateStatus = (status, postId, publishDate) ->
      fd = new FormData
      fd.append 'token', $localStorage['token']
      fd.append 'email', $localStorage['email']
      fd.append 'post[status]', status
      fd.append 'post[published_at]', publishDate

      # データ登録
      url = Const.API.POST + "/" + postId
      method = Const.METHOD.PATCH

      msg = $translate.instant('MSG.INFO.PUBLISHED')
      if status == 0
        msg = $translate.instant('MSG.INFO.UNPUBLISHED')

      Api.saveFormData(fd, url, method).then (res) ->
        $scope.popoverPostMenu.hide()
        # 初期化処理実行
        $scope.init()
        toaster.pop
          type: 'success'
          title: msg
          showCloseButton: true

    $scope.setEyeCatch = ($index) ->
      # メイン画像のチェック
      if $index == -1
        $scope.input.isEyeCatch = true
      else
        $scope.input.isEyeCatch = false

      # サブ画像のチェック
      angular.forEach $scope.input.details, (detail, i) ->
        if i == $index
          detail.isEyeCatch = true
        else
          detail.isEyeCatch = false
