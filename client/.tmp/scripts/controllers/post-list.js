(function() {
  'use strict';

  /**
    * @ngdoc function
    * @name frontApp.controller:PostListCtrl
    * @description
    * # PostListCtrl
    * Controller of the frontApp
   */
  angular.module("frontApp").controller("PostListCtrl", function($scope, $rootScope, $ionicSideMenuDelegate, $ionicModal, $ionicPopover, $ionicPopup, $ionicSlideBoxDelegate, $sessionStorage, Api, Const, toaster) {
    var accessKey, categoryObj, clearInput, deletePosts, watchSubFile;
    $ionicModal.fromTemplateUrl('views/parts/modal-post.html', {
      scope: $scope,
      animation: 'slide-in-up',
      backdropClickToClose: false
    }).then(function(modalPost) {
      return $scope.modalPost = modalPost;
    });
    $ionicModal.fromTemplateUrl('views/parts/modal-shops.html', {
      scope: $scope,
      animation: 'slide-in-up',
      backdropClickToClose: false
    }).then(function(modalShops) {
      return $scope.modalShops = modalShops;
    });
    $ionicModal.fromTemplateUrl('views/parts/modal-people.html', {
      scope: $scope,
      animation: 'slide-in-up',
      backdropClickToClose: false
    }).then(function(modalPeople) {
      return $scope.modalPeople = modalPeople;
    });
    $ionicPopover.fromTemplateUrl('views/parts/popover-post-menu.html', {
      scope: $scope
    }).then(function(popoverPostMenu) {
      return $scope.popoverPostMenu = popoverPostMenu;
    });
    $scope.categories = [{}];
    categoryObj = {
      type: "PostCategory"
    };
    Api.getJson(categoryObj, Const.API.CATEGORY).then(function(res) {
      $scope.categories = res.data;
      return $scope.categories[0].checked = true;
    });
    $scope.isShowBackSlide = false;
    $scope.isShowAddPostDetail = true;
    $scope.slideLists = [1, 2, 3];
    $scope.showDeleteButton = false;
    $scope.isEditing = false;
    clearInput = function() {
      var detail, details, input, slideList, _i, _len, _ref;
      details = [];
      _ref = $scope.slideLists;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        slideList = _ref[_i];
        detail = {
          index: slideList,
          subTitle: null,
          subContent: null,
          subQuotationUrl: null,
          subQuotationName: null,
          id: null
        };
        details.push(detail);
      }
      input = {
        title: null,
        content: null,
        quotationUrl: null,
        quotationName: null,
        details: details,
        category: $scope.categories[0],
        id: null,
        authentication_token: $sessionStorage['token']
      };
      $scope.input = input;
      angular.forEach($scope.categories, function(category, i) {
        return category.checked = false;
      });
      $scope.categories[0].checked = true;
      angular.forEach(angular.element("input[type='file']"), function(inputElem) {
        return angular.element(inputElem).val(null);
      });
      $ionicSlideBoxDelegate.slide(0);
      $scope.isShowBackSlide = false;
      $scope.isShowAddPostDetail = true;
      return $scope.showDeleteButton = false;
    };
    clearInput();
    accessKey = {
      email: $sessionStorage['email'],
      token: $sessionStorage['token']
    };
    $scope.init = function() {
      $scope.results = "";
      if ($sessionStorage['token']) {
        return Api.getJson(accessKey, Const.API.POST).then(function(res) {
          $scope.results = res.data;
          return $scope.$broadcast('scroll.refreshComplete');
        });
      }
    };
    $scope.openModalPost = function() {
      clearInput();
      $scope.isEditing = false;
      return $scope.modalPost.show();
    };
    $scope.closeModalPost = function(targetForm) {
      targetForm.$setPristine();
      return $scope.modalPost.hide();
    };
    $scope.openModalShops = function() {
      Api.getJson("", Const.API.SHOP + '.json').then(function(resShop) {
        var obj;
        $scope.shops = resShop.data;
        obj = {
          post_id: $scope.targetPostId
        };
        return Api.getJson(obj, Const.API.POST_SHOP).then(function(resPostShop) {
          return angular.forEach($scope.shops, function(shop) {
            shop.checked = false;
            return angular.forEach(resPostShop.data, function(postShop) {
              if (postShop.shop_id === shop.id) {
                return shop.checked = true;
              }
            });
          });
        });
      });
      return $scope.modalShops.show();
    };
    $scope.closeModalShops = function() {
      return $scope.modalShops.hide();
    };
    $scope.openModalPeople = function() {
      Api.getJson("", Const.API.PERSON + '.json').then(function(resPerson) {
        var obj;
        $scope.people = resPerson.data;
        obj = {
          post_id: $scope.targetPostId
        };
        return Api.getJson(obj, Const.API.POST_PERSON).then(function(resPostPerson) {
          return angular.forEach($scope.people, function(person) {
            person.checked = false;
            return angular.forEach(resPostPerson.data, function(postPerson) {
              if (postPerson.person_id === person.id) {
                return person.checked = true;
              }
            });
          });
        });
      });
      return $scope.modalPeople.show();
    };
    $scope.closeModalPeople = function() {
      return $scope.modalPeople.hide();
    };
    $scope.openPopoverPostMenu = function($event, $index) {
      $scope.targetIndex = $index;
      $scope.targetPostId = $scope.results[$index].id;
      $scope.targetStatus = $scope.results[$index].status;
      return $scope.popoverPostMenu.show($event);
    };
    $scope.closePopoverPostMenu = function() {
      return $scope.popoverPostMenu.hide();
    };
    $scope.doPost = function(targetForm) {
      var fd, fdDetails, method, msg, targetSlug, url;
      if ($scope.input.title && $scope.srcUrl) {
        targetSlug = null;
        angular.forEach($scope.categories, function(category) {
          if (category.checked) {
            return targetSlug = category.slug;
          }
        });
        fd = new FormData;
        fdDetails = new FormData;
        fd.append('token', $sessionStorage['token']);
        fd.append('email', $sessionStorage['email']);
        if (targetSlug) {
          fd.append('slug', targetSlug);
        }
        if ($scope.input.title) {
          fd.append('post[title]', $scope.input.title.trim());
        }
        if ($scope.input.file) {
          fd.append('post[image]', $scope.input.file);
        }
        if ($scope.input.content) {
          fd.append('post[content]', $scope.input.content);
        }
        if ($scope.input.quotationUrl) {
          fd.append('post[quotation_url]', $scope.input.quotationUrl);
        }
        if ($scope.input.quotationName) {
          fd.append('post[quotation_name]', $scope.input.quotationName);
        }
        url = Const.API.POST;
        method = Const.METHOD.POST;
        msg = Const.MSG.SAVED;
        if ($scope.input.id) {
          url += "/" + $scope.input.id;
          method = Const.METHOD.PATCH;
          msg = Const.MSG.UPDATED;
        }
        return Api.saveFormData(fd, url, method).then(function(res) {
          var detailCount;
          $scope.init();
          detailCount = 0;
          angular.forEach($scope.input.details, function(detail, i) {
            var fdDetail;
            if (detail.subTitle || detail.subFile || detail.subContent) {
              fdDetail = new FormData;
              fdDetails.append('post_details[][post_id]', res.data.id);
              if (detail.subTitle) {
                fdDetails.append('post_details[][title]', detail.subTitle.trim());
              }
              if (detail.subFile) {
                fdDetails.append('post_details[][image]', detail.subFile);
              }
              if (detail.subContent) {
                fdDetails.append('post_details[][content]', detail.subContent);
              }
              if (detail.subQuotationUrl) {
                fdDetails.append('post_details[][quotation_url]', detail.subQuotationUrl);
              }
              if (detail.subQuotationName) {
                fdDetails.append('post_details[][quotation_name]', detail.subQuotationName);
              }
              if (detail.id) {
                fdDetails.append('post_details[][id]', detail.id);
              }
              return detailCount += 1;
            }
          });
          if (detailCount > 0) {
            return Api.saveFormData(fdDetails, Const.API.POST_DETSIL, Const.METHOD.POST).then(function(res) {
              clearInput();
              targetForm.$setPristine();
              $scope.modalPost.hide();
              $scope.popoverPostMenu.hide();
              return toaster.pop({
                type: 'success',
                title: msg,
                showCloseButton: true
              });
            });
          } else {
            clearInput();
            targetForm.$setPristine();
            $scope.modalPost.hide();
            return toaster.pop({
              type: 'success',
              title: msg,
              showCloseButton: true
            });
          }
        });
      }
    };
    $scope.doDelete = function() {
      return $ionicPopup.show({
        title: '削除してよろしいですか？',
        scope: $scope,
        buttons: [
          {
            text: 'キャンセル'
          }, {
            text: '<b>OK</b>',
            type: 'button-dark',
            onTap: function(e) {
              return deletePosts();
            }
          }
        ]
      });
    };
    deletePosts = function() {
      var deleteCount, resultLength;
      $scope.showDeleteButton = false;
      accessKey = {
        email: $sessionStorage['email'],
        token: $sessionStorage['token']
      };
      deleteCount = 0;
      resultLength = 0;
      angular.forEach($scope.results, function(result, index) {
        if (result.checked) {
          return resultLength += 1;
        }
      });
      return angular.forEach($scope.results, function(result, index) {
        var targetPostId;
        if (result.checked) {
          targetPostId = result.id;
          return Api.deleteJson(accessKey, targetPostId, Const.API.POST).then(function(res) {
            $scope.results.splice(index - deleteCount, 1);
            deleteCount += 1;
            return Api.deleteJson(accessKey, targetPostId, Const.API.POST_DETSIL).then(function(res) {
              if (resultLength === deleteCount) {
                return toaster.pop({
                  type: 'success',
                  title: '削除しました。',
                  showCloseButton: true
                });
              }
            });
          });
        }
      });
    };
    $scope.onEditButton = function(index) {
      clearInput();
      $scope.isEditing = true;
      return Api.getJson("", Const.API.POST_DETSIL + '/' + $scope.results[index].id).then(function(res) {
        var details;
        $scope.checkCategory($scope.results[index].category_id);
        details = [];
        angular.forEach($scope.slideLists, function(slideList, i) {
          var detail;
          detail = {
            index: slideList,
            subTitle: res.data[i] ? res.data[i].title : null,
            subContent: res.data[i] ? res.data[i].content : null,
            subQuotationUrl: res.data[i] ? res.data[i].quotation_url : null,
            subQuotationName: res.data[i] ? res.data[i].quotation_name : null,
            srcSubUrl: res.data[i] ? res.data[i].image.thumb.url : null,
            id: res.data[i] ? res.data[i].id : null
          };
          return details.push(detail);
        });
        $scope.input = {
          title: $scope.results[index].title,
          content: $scope.results[index].content,
          quotationUrl: $scope.results[index].quotation_url,
          quotationName: $scope.results[index].quotation_name,
          details: details,
          category: {
            name: $scope.results[index].category_name,
            slug: $scope.results[index].category_slug
          },
          id: $scope.results[index].id
        };
        $scope.srcUrl = $scope.results[index].image.thumb.url;
        return $scope.modalPost.show();
      });
    };
    $scope.$watch('input.file', function(file) {
      var reader;
      $scope.srcUrl = void 0;
      if (!file || !file.type.match('image.*')) {
        return;
      }
      reader = new FileReader;
      reader.onload = function() {
        return $scope.$apply(function() {
          return $scope.srcUrl = reader.result;
        });
      };
      return reader.readAsDataURL(file);
    });
    $scope.$watch('input.details[0].subFile', function(file) {
      return watchSubFile(0, file);
    });
    $scope.$watch('input.details[1].subFile', function(file) {
      return watchSubFile(1, file);
    });
    $scope.$watch('input.details[2].subFile', function(file) {
      return watchSubFile(2, file);
    });
    watchSubFile = function(index, file) {
      var reader;
      $scope.input.details[index].srcSubUrl = void 0;
      if (!file || !file.type.match('image.*')) {
        return;
      }
      reader = new FileReader;
      reader.onload = function() {
        return $scope.$apply(function() {
          return $scope.input.details[index].srcSubUrl = reader.result;
        });
      };
      return reader.readAsDataURL(file);
    };
    $scope.prevSlide = function() {
      $ionicSlideBoxDelegate.next();
      $scope.isShowBackSlide = true;
      if ($ionicSlideBoxDelegate.currentIndex() >= 3) {
        return $scope.isShowAddPostDetail = false;
      }
    };
    $scope.backSlide = function() {
      $ionicSlideBoxDelegate.previous();
      $scope.isShowAddPostDetail = true;
      if ($ionicSlideBoxDelegate.currentIndex() === 0) {
        return $scope.isShowBackSlide = false;
      }
    };
    $scope.onCheckbox = function(result) {
      var isChecked;
      if (!result.checked) {
        result.checked = true;
        return $scope.showDeleteButton = true;
      } else {
        result.checked = false;
        isChecked = false;
        angular.forEach($scope.results, function(result, key) {
          if (result.checked) {
            return isChecked = true;
          }
        });
        if (!isChecked) {
          return $scope.showDeleteButton = false;
        }
      }
    };
    $scope.checkCategory = function(id) {
      return angular.forEach($scope.categories, function(category, i) {
        if (id === category.id) {
          category.checked = true;
          return $scope.targetCategorySlug = category.slug;
        } else {
          return category.checked = false;
        }
      });
    };
    $scope.saveShops = function() {
      var obj, shopIds;
      shopIds = [];
      angular.forEach($scope.shops, function(shop) {
        if (shop.checked) {
          return shopIds.push(shop.id);
        }
      });
      obj = {
        post_id: $scope.targetPostId,
        shop_ids: shopIds
      };
      return Api.saveJson(obj, Const.API.POST_SHOP, Const.METHOD.POST).then(function(res) {
        $scope.modalShops.hide();
        $scope.popoverPostMenu.hide();
        return toaster.pop({
          type: 'success',
          title: '保存しました。',
          showCloseButton: true
        });
      });
    };
    $scope.savePeople = function() {
      var obj, personIds;
      personIds = [];
      angular.forEach($scope.people, function(person) {
        if (person.checked) {
          return personIds.push(person.id);
        }
      });
      obj = {
        post_id: $scope.targetPostId,
        person_ids: personIds
      };
      return Api.saveJson(obj, Const.API.POST_PERSON, Const.METHOD.POST).then(function(res) {
        $scope.modalPeople.hide();
        $scope.popoverPostMenu.hide();
        return toaster.pop({
          type: 'success',
          title: '保存しました。',
          showCloseButton: true
        });
      });
    };
    return $scope.updateStatus = function(status) {
      var fd, method, msg, url;
      fd = new FormData;
      fd.append('token', $sessionStorage['token']);
      fd.append('email', $sessionStorage['email']);
      fd.append('post[status]', status);
      url = Const.API.POST + "/" + $scope.targetPostId;
      method = Const.METHOD.PATCH;
      msg = Const.MSG.PUBLISHED;
      if (status === 0) {
        msg = Const.MSG.UNPUBLISHED;
      }
      return Api.saveFormData(fd, url, method).then(function(res) {
        $scope.popoverPostMenu.hide();
        $scope.init();
        return toaster.pop({
          type: 'success',
          title: msg,
          showCloseButton: true
        });
      });
    };
  });

}).call(this);

//# sourceMappingURL=post-list.js.map
