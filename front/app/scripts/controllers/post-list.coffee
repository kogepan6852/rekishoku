'use strict'

###*
 # @ngdoc function
 # @name frontApp.controller:PostListCtrl
 # @description
 # # PostListCtrl
 # Controller of the frontApp
###
angular.module "frontApp"
  .controller "PostListCtrl", ($scope, $rootScope, $ionicSideMenuDelegate, $ionicModal, $ionicPopover, $ionicPopup, $ionicSlideBoxDelegate, $sessionStorage, Api, Const, toaster) ->

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
    Api.getJson(categoryObj, Const.API.CATEGORY).then (res) ->
      $scope.categories = res.data
      $scope.categories[0].checked = true

    $scope.isShowBackSlide = false
    $scope.isShowAddPostDetail = true;
    $scope.slideLists = [1, 2, 3]
    $scope.showDeleteButton = false
    $scope.isEditing = false

    # 初期処理
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
        authentication_token: $sessionStorage['token']
      $scope.input = input
      # categoryの初期化
      angular.forEach $scope.categories, (category, i) ->
        category.checked = false
      $scope.categories[0].checked = true

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

    $scope.init = ->
      $scope.results = ""
      # post取得
      if ($sessionStorage['token'])
        Api.getJson(accessKey, Const.API.POST).then (res) ->
          $scope.results = res.data
          $scope.$broadcast 'scroll.refreshComplete'

    # Function
    $scope.openModalPost = () ->
      clearInput()
      $scope.isEditing = false
      $scope.modalPost.show()

    $scope.closeModalPost = (targetForm) ->
      targetForm.$setPristine()
      $scope.modalPost.hide()

    $scope.openModalShops = () ->
      # 店舗一覧を取得する
      Api.getJson("", Const.API.SHOP + '.json').then (resShop) ->
        $scope.shops = resShop.data
        # 紐づく店舗を取得する
        obj =
          post_id: $scope.targetPostId
        Api.getJson(obj, Const.API.POST_SHOP).then (resPostShop) ->
          angular.forEach $scope.shops, (shop) ->
            shop.checked = false
            angular.forEach resPostShop.data, (postShop) ->
              if postShop.shop_id == shop.id
                shop.checked = true

      # モーダルを開く
      $scope.modalShops.show()

    $scope.closeModalShops = () ->
      $scope.modalShops.hide()

    $scope.openModalPeople = () ->
      # 人物一覧を取得する
      Api.getJson("", Const.API.PERSON + '.json').then (resPerson) ->
        $scope.people = resPerson.data
        # 紐づく店舗を取得する
        obj =
          post_id: $scope.targetPostId
        Api.getJson(obj, Const.API.POST_PERSON).then (resPostPerson) ->
          angular.forEach $scope.people, (person) ->
            person.checked = false
            angular.forEach resPostPerson.data, (postPerson) ->
              if postPerson.person_id == person.id
                person.checked = true

      # モーダルを開く
      $scope.modalPeople.show()

    $scope.closeModalPeople = () ->
      $scope.modalPeople.hide()

    $scope.openPopoverPostMenu = ($event, $index) ->
      $scope.targetIndex = $index
      $scope.targetPostId = $scope.results[$index].id
      $scope.targetStatus = $scope.results[$index].status
      $scope.popoverPostMenu.show $event

    $scope.closePopoverPostMenu = ->
      $scope.popoverPostMenu.hide()

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
        fd.append 'token', $sessionStorage['token']
        fd.append 'email', $sessionStorage['email']
        if targetSlug then fd.append 'slug', targetSlug
        if $scope.input.title then fd.append 'post[title]', $scope.input.title.trim()
        if $scope.input.file then fd.append 'post[image]', $scope.input.file
        if $scope.input.content then fd.append 'post[content]', $scope.input.content
        if $scope.input.quotationUrl then fd.append 'post[quotation_url]', $scope.input.quotationUrl
        if $scope.input.quotationName then fd.append 'post[quotation_name]', $scope.input.quotationName

        # データ登録
        url = Const.API.POST
        method = Const.METHOD.POST
        msg = Const.MSG.SAVED
        # 更新の場合、idを設定する
        if $scope.input.id
          url += "/" + $scope.input.id
          method = Const.METHOD.PATCH
          msg = Const.MSG.UPDATED

        Api.saveFormData(fd, url, method).then (res) ->
          # 初期化処理実行
          $scope.init()
          detailCount = 0

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

    $scope.doDelete = ->
      $ionicPopup.show(
        title: '削除してよろしいですか？'
        scope: $scope
        buttons: [
          { text: 'キャンセル' }
          {
            text: '<b>OK</b>'
            type: 'button-dark'
            onTap: (e) ->
              deletePosts()
          }
        ])

    deletePosts = ->
      $scope.showDeleteButton = false
      # login情報
      accessKey =
        email: $sessionStorage['email']
        token: $sessionStorage['token']
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
                  title: '削除しました。',
                  showCloseButton: true


    $scope.onEditButton = (index) ->
      clearInput()
      $scope.isEditing = true
      Api.getJson("", Const.API.POST_DETSIL + '/' + $scope.results[index].id).then (res) ->
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
            srcSubUrl: if res.data[i] then res.data[i].image.thumb.url else null
            id: if res.data[i] then res.data[i].id else null
          details.push(detail)
        # postの作成
        $scope.input =
          title: $scope.results[index].title
          content: $scope.results[index].content
          quotationUrl: $scope.results[index].quotation_url
          quotationName: $scope.results[index].quotation_name
          details: details
          category:
            name: $scope.results[index].category_name
            slug: $scope.results[index].category_slug
          id: $scope.results[index].id
        $scope.srcUrl = $scope.results[index].image.thumb.url
        $scope.modalPost.show()

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

    $scope.checkCategory = (id) ->
      angular.forEach $scope.categories, (category, i) ->
        if id == category.id
          category.checked = true
          $scope.targetCategorySlug = category.slug
        else
          category.checked = false

    $scope.saveShops = ->
      shopIds = []
      angular.forEach $scope.shops, (shop) ->
        if shop.checked
          shopIds.push(shop.id)

      obj =
        post_id: $scope.targetPostId
        shop_ids: shopIds

      Api.saveJson(obj, Const.API.POST_SHOP, Const.METHOD.POST).then (res) ->
        $scope.modalShops.hide()
        $scope.popoverPostMenu.hide()
        toaster.pop
          type: 'success',
          title: '保存しました。',
          showCloseButton: true

    $scope.savePeople = ->
      personIds = []
      angular.forEach $scope.people, (person) ->
        if person.checked
          personIds.push(person.id)

      obj =
        post_id: $scope.targetPostId
        person_ids: personIds

      Api.saveJson(obj, Const.API.POST_PERSON, Const.METHOD.POST).then (res) ->
        $scope.modalPeople.hide()
        $scope.popoverPostMenu.hide()
        toaster.pop
          type: 'success',
          title: '保存しました。',
          showCloseButton: true

    $scope.updateStatus = (status) ->
      fd = new FormData
      fd.append 'token', $sessionStorage['token']
      fd.append 'email', $sessionStorage['email']
      fd.append 'post[status]', status

      # データ登録
      url = Const.API.POST + "/" + $scope.targetPostId
      method = Const.METHOD.PATCH

      msg = Const.MSG.PUBLISHED
      if status == 0
        msg = Const.MSG.UNPUBLISHED

      Api.saveFormData(fd, url, method).then (res) ->
        $scope.popoverPostMenu.hide()
        # 初期化処理実行
        $scope.init()
        toaster.pop
          type: 'success'
          title: msg
          showCloseButton: true
