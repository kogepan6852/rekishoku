(function() {
  'use strict';

  /**
    * @ngdoc overview
    * @name frontApp
    * @description
    * # frontApp
    *
    * Main module of the application.
   */
  angular.module('frontApp', ['ngAnimate', 'ngCookies', 'ngResource', 'ngRoute', 'ngSanitize', 'ngTouch', 'ionic', 'ui.router', 'ngStorage', 'toaster', 'uiGmapgoogle-maps', 'config']).config(["$stateProvider", "$urlRouterProvider", function($stateProvider, $urlRouterProvider) {
    $stateProvider.state('home', {
      url: "/home",
      templateUrl: "views/tabs.html"
    }).state('post', {
      cache: false,
      url: '/post/:id',
      templateUrl: 'views/post-detail.html',
      controller: 'PostDetailCtrl'
    }).state('shop', {
      cache: false,
      url: '/shop/:id',
      templateUrl: 'views/shop-detail.html',
      controller: 'ShopDetailCtrl'
    }).state('my-post', {
      cache: false,
      url: '/my-post',
      templateUrl: 'views/post-list.html',
      controller: 'PostListCtrl'
    }).state('writers', {
      url: '/writers',
      templateUrl: 'views/writers.html',
      controller: 'WritersCtrl'
    }).state('writer', {
      cache: false,
      url: '/writer/:id',
      templateUrl: 'views/writer-detail.html',
      controller: 'WriterDetailCtrl'
    });
    return $urlRouterProvider.otherwise('/home');
  }]).config([
    "$httpProvider", function($httpProvider) {
      $httpProvider.defaults.transformRequest = function(data) {
        if (data === undefined) {
          return data;
        }
        return $.param(data);
      };
      return $httpProvider.defaults.headers.post = {
        "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
      };
    }
  ]).config(["$ionicConfigProvider", function($ionicConfigProvider) {
    $ionicConfigProvider.views.maxCache(5);
    $ionicConfigProvider.views.transition('ios');
    return $ionicConfigProvider.views.forwardCache(true);
  }]);

}).call(this);

//# sourceMappingURL=app.js.map

angular.module('config', [])

.constant('config', {env:'production',url:{api:''}})

;
(function() {
  'use strict';

  /**
    * @ngdoc function
    * @name frontApp.controller:MainCtrl
    * @description
    * # MainCtrl
    * Controller of the frontApp
   */
  angular.module("frontApp").controller("MainCtrl", ["$scope", "$ionicSideMenuDelegate", "Api", "Const", function($scope, $ionicSideMenuDelegate, Api, Const) {
    var categoryObj;
    $scope.targetCategoryId = null;
    $scope.page = 1;
    $scope.noMoreLoad = false;
    categoryObj = {
      type: "PostCategory"
    };
    Api.getJson(categoryObj, Const.API.CATEGORY).then(function(res) {
      return $scope.categories = res.data;
    });
    $scope.init = function() {
      var obj;
      obj = {
        per: 20,
        page: 1
      };
      return Api.getJson(obj, Const.API.POST).then(function(res) {
        $scope.posts = res.data;
        $scope.$broadcast('scroll.refreshComplete');
        return $scope.targetCategoryId = null;
      });
    };
    $scope.search = function(categoryId) {
      var obj;
      if (categoryId === $scope.targetCategoryId) {
        $scope.targetCategoryId = null;
        obj = "";
      } else {
        $scope.targetCategoryId = categoryId;
        obj = {
          category: categoryId
        };
      }
      return Api.getJson(obj, Const.API.POST).then(function(res) {
        return $scope.posts = res.data;
      });
    };
    return $scope.loadMoreData = function() {
      var obj;
      $scope.page += 1;
      obj = {
        per: 20,
        page: $scope.page,
        category: $scope.targetCategoryId
      };
      return Api.getJson(obj, Const.API.POST).then(function(res) {
        if (res.data.length === 0) {
          return $scope.noMoreLoad = true;
        } else {
          angular.forEach(res.data, function(data, i) {
            return $scope.posts.push(data);
          });
          return $scope.$broadcast('scroll.infiniteScrollComplete');
        }
      });
    };
  }]);

}).call(this);

//# sourceMappingURL=main.js.map

(function() {
  'use strict';

  /**
    * @ngdoc function
    * @name frontApp.controller:HeaderCtrl
    * @description
    * # HeaderCtrl
    * Controller of the frontApp
   */
  angular.module("frontApp").controller("HeaderCtrl", ["$scope", "$rootScope", "$timeout", "$ionicSideMenuDelegate", "$ionicModal", "$ionicPopup", "$sessionStorage", "$location", "Api", "toaster", "Const", function($scope, $rootScope, $timeout, $ionicSideMenuDelegate, $ionicModal, $ionicPopup, $sessionStorage, $location, Api, toaster, Const) {
    var clearInput;
    $ionicModal.fromTemplateUrl('views/parts/modal-login.html', {
      scope: $scope,
      animation: 'slide-in-up'
    }).then(function(modalLogin) {
      return $scope.modalLogin = modalLogin;
    });
    if (!$sessionStorage['token']) {
      $rootScope.isLogin = false;
    } else {
      $rootScope.isLogin = true;
    }
    $scope.showLogin = false;
    if ($location.search()["showLogin"]) {
      $scope.showLogin = true;
    }
    clearInput = function() {
      var input;
      input = {
        email: "",
        password: "",
        password_confirmation: ""
      };
      return $scope.input = input;
    };
    clearInput();
    if ($sessionStorage['email']) {
      $scope.input.email = $sessionStorage['email'];
    }
    $scope.openModalLogin = function() {
      return $scope.modalLogin.show();
    };
    $scope.hideModalLogin = function() {
      return $scope.modalLogin.hide();
    };
    $scope.toggleRight = function() {
      return $ionicSideMenuDelegate.toggleRight();
    };
    $scope.doLogin = function() {
      var obj;
      obj = {
        "user[email]": $scope.input.email,
        "user[password]": $scope.input.password
      };
      return Api.postJson(obj, Const.API.LOGIN).then(function(res) {
        $ionicSideMenuDelegate.toggleRight();
        $scope.modalLogin.hide();
        clearInput();
        $sessionStorage['email'] = res.data.email;
        $sessionStorage['token'] = res.data.authentication_token;
        $sessionStorage['user_id'] = res.data.id;
        $rootScope.isLogin = true;
        return toaster.pop({
          type: 'success',
          title: Const.MSG.LOGED_IN,
          showCloseButton: true
        });
      });
    };
    $scope.doLogout = function() {
      return $ionicPopup.show({
        title: 'ログアウトしてよろしいですか？',
        scope: $scope,
        buttons: [
          {
            text: 'キャンセル'
          }, {
            text: '<b>OK</b>',
            type: 'button-dark',
            onTap: function(e) {
              var accessKey;
              $rootScope.isLogin = false;
              accessKey = {
                email: $sessionStorage['email'],
                token: $sessionStorage['token']
              };
              return Api.logOut(accessKey, Const.API.LOGOUT).then(function(res) {
                $ionicSideMenuDelegate.toggleRight();
                clearInput();
                delete $sessionStorage['token'];
                delete $sessionStorage['email'];
                delete $sessionStorage['user_id'];
                return $location.path('/home/');
              });
            }
          }
        ]
      });
    };
    $scope.doSignUp = function() {
      var obj;
      obj = {
        "user[email]": $scope.input.email,
        "user[password]": $scope.input.password,
        "user[password_confirmation]": $scope.input.password_confirmation
      };
      return Api.saveJson(obj, Const.API.USER, Const.METHOD.POST).then(function(res) {
        $scope.doLogin();
        $scope.modalLogin.hide();
        clearInput();
        return toaster.pop({
          type: 'success',
          title: Const.MSG.SINGED_UP,
          showCloseButton: true
        });
      });
    };
    $scope.closeMenu = function() {
      return $ionicSideMenuDelegate.toggleRight();
    };
    return $scope.moveToWriterDetail = function() {
      var userId;
      userId = $sessionStorage['user_id'];
      $location.path('/writer/' + userId);
      return $ionicSideMenuDelegate.toggleRight();
    };
  }]);

}).call(this);

//# sourceMappingURL=header.js.map

(function() {
  'use strict';

  /**
    * @ngdoc function
    * @name frontApp.controller:AboutCtrl
    * @description
    * # AboutCtrl
    * Controller of the frontApp
   */
  angular.module('frontApp').controller('MapCtrl', ["$scope", "$rootScope", "$window", "$sessionStorage", "$ionicSideMenuDelegate", "Api", "toaster", "BaseService", "Const", function($scope, $rootScope, $window, $sessionStorage, $ionicSideMenuDelegate, Api, toaster, BaseService, Const) {
    var defaultZoom, setMapData, targetDistance;
    $scope.input = {
      address: null
    };
    defaultZoom = 14;
    targetDistance = BaseService.calMapDistance(defaultZoom);
    $scope.map = {
      center: {
        latitude: 35.6813818,
        longitude: 139.7660838
      },
      zoom: defaultZoom,
      bounds: {}
    };
    $scope.options = {
      scrollwheel: false,
      minZoom: 11
    };
    $scope.events = {
      dragstart: function(cluster, clusterModels) {
        return $ionicSideMenuDelegate.canDragContent(false);
      },
      dragend: function(cluster, clusterModels) {
        var obj;
        $ionicSideMenuDelegate.canDragContent(true);
        obj = {
          latitude: cluster.center.G,
          longitude: cluster.center.K,
          shopDistance: targetDistance
        };
        return setMapData(obj);
      },
      zoom_changed: function(cluster, clusterModels) {
        var obj;
        targetDistance = BaseService.calMapDistance(cluster.zoom);
        obj = {
          placeAddress: $scope.input.address,
          shopDistance: targetDistance
        };
        return setMapData(obj);
      }
    };
    $scope.targetMarkers = [];
    $scope.init = function() {
      if (navigator.geolocation) {
        return navigator.geolocation.getCurrentPosition((function(position) {
          var obj;
          $scope.map.center.latitude = position.coords.latitude;
          $scope.map.center.longitude = position.coords.longitude;
          obj = {
            latitude: position.coords.latitude,
            longitude: position.coords.longitude,
            shopDistance: targetDistance
          };
          return setMapData(obj);
        }), function(e) {
          if (typeof e === 'string') {
            return alert(e);
          } else {
            return alert(e.message);
          }
        });
      } else {
        return alert('位置情報を取得できません。');
      }
    };
    $scope.searchShops = function() {
      var obj;
      obj = {
        placeAddress: $scope.input.address,
        shopDistance: targetDistance
      };
      return setMapData(obj);
    };
    setMapData = function(obj) {
      return Api.getJson(obj, Const.API.SHOP + "/api.json").then(function(resShops) {
        var shops;
        $scope.map.center.latitude = resShops.data.current.latitude;
        $scope.map.center.longitude = resShops.data.current.longitude;
        $scope.input.address = resShops.data.current.address;
        shops = [];
        angular.forEach(resShops.data.shops, function(shop, i) {
          var ret;
          ret = {
            latitude: shop.latitude,
            longitude: shop.longitude,
            showWindow: true,
            title: shop.name,
            url: shop.image.thumb.url
          };
          ret['id'] = shop.id;
          return shops.push(ret);
        });
        return $scope.targetMarkers = shops;
      });
    };
    return $scope.clickMarker = function($event) {};
  }]);

}).call(this);

//# sourceMappingURL=map.js.map

(function() {
  'use strict';

  /**
    * @ngdoc function
    * @name frontApp.controller:ShopsCtrl
    * @description
    * # MainCtrl
    * Controller of the frontApp
   */
  angular.module("frontApp").controller("ShopsCtrl", ["$scope", "$ionicSideMenuDelegate", "Api", "Const", function($scope, $ionicSideMenuDelegate, Api, Const) {
    var categoryObj;
    $scope.targetCategoryId = null;
    $scope.page = 1;
    $scope.noMoreLoad = false;
    categoryObj = {
      type: "ShopCategory"
    };
    Api.getJson(categoryObj, Const.API.CATEGORY).then(function(res) {
      return $scope.categories = res.data;
    });
    $scope.init = function() {
      var obj;
      obj = {
        per: 20,
        page: 1
      };
      return Api.getJson(obj, Const.API.SHOP + '/api.json').then(function(res) {
        $scope.results = res.data;
        $scope.$broadcast('scroll.refreshComplete');
        return $scope.targetCategoryId = null;
      });
    };
    $scope.search = function(categoryId) {
      var obj;
      if (categoryId === $scope.targetCategoryId) {
        $scope.targetCategoryId = null;
        obj = "";
      } else {
        $scope.targetCategoryId = categoryId;
        obj = {
          category: categoryId
        };
      }
      return Api.getJson(obj, Const.API.SHOP + '/api.json').then(function(res) {
        return $scope.results = res.data;
      });
    };
    return $scope.loadMoreData = function() {
      var obj;
      $scope.page += 1;
      obj = {
        per: 20,
        page: $scope.page,
        category: $scope.targetCategoryId
      };
      return Api.getJson(obj, Const.API.SHOP + '/api.json').then(function(res) {
        if (res.data.length === 0) {
          return $scope.noMoreLoad = true;
        } else {
          angular.forEach(res.data, function(data, i) {
            return $scope.results.push(data);
          });
          return $scope.$broadcast('scroll.infiniteScrollComplete');
        }
      });
    };
  }]);

}).call(this);

//# sourceMappingURL=shops.js.map

(function() {
  'use strict';

  /**
    * @ngdoc function
    * @name frontApp.controller:ShopDetailCtrl
    * @description
    * # PostDetailCtrl
    * Controller of the frontApp
   */
  angular.module('frontApp').controller("ShopDetailCtrl", ["$scope", "$stateParams", "$sessionStorage", "Api", "Const", function($scope, $stateParams, $sessionStorage, Api, Const) {
    $scope.targetId = $stateParams.id;
    return Api.getJson("", Const.API.SHOP + '/' + $stateParams.id + '.json').then(function(res) {
      var ret, shops;
      $scope.shop = res.data.shop;
      $scope.categories = res.data.categories;
      $scope.posts = res.data.posts;
      $scope.map = {
        center: {
          latitude: res.data.shop.latitude,
          longitude: res.data.shop.longitude
        },
        zoom: 14,
        bounds: {}
      };
      $scope.options = {
        scrollwheel: false,
        minZoom: 11
      };
      shops = [];
      ret = {
        latitude: res.data.shop.latitude,
        longitude: res.data.shop.longitude,
        showWindow: true,
        title: res.data.shop.name,
        url: res.data.shop.image.thumb.url
      };
      ret['id'] = res.data.shop.id;
      shops.push(ret);
      return $scope.targetMarkers = shops;
    });
  }]);

}).call(this);

//# sourceMappingURL=shop-detail.js.map

(function() {
  'use strict';

  /**
    * @ngdoc function
    * @name frontApp.controller:PostListCtrl
    * @description
    * # PostListCtrl
    * Controller of the frontApp
   */
  angular.module("frontApp").controller("PostListCtrl", ["$scope", "$rootScope", "$ionicSideMenuDelegate", "$ionicModal", "$ionicPopover", "$ionicPopup", "$ionicSlideBoxDelegate", "$sessionStorage", "Api", "Const", "toaster", function($scope, $rootScope, $ionicSideMenuDelegate, $ionicModal, $ionicPopover, $ionicPopup, $ionicSlideBoxDelegate, $sessionStorage, Api, Const, toaster) {
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
  }]);

}).call(this);

//# sourceMappingURL=post-list.js.map

(function() {
  'use strict';

  /**
    * @ngdoc function
    * @name frontApp.controller:PostDetailCtrl
    * @description
    * # PostDetailCtrl
    * Controller of the frontApp
   */
  angular.module('frontApp').controller("PostDetailCtrl", ["$scope", "$stateParams", "$ionicHistory", "$sessionStorage", "Api", "Const", function($scope, $stateParams, $ionicHistory, $sessionStorage, Api, Const) {
    var path;
    $scope.targetId = $stateParams.id;
    path = Const.API.POST + '/' + $stateParams.id;
    Api.getJson("", path).then(function(res) {
      $scope.post = res.data.post;
      $scope.shops = res.data.shops;
      return Api.getJson("", Const.API.POST_DETSIL + '/' + res.data.post.id).then(function(res) {
        return $scope.postDetails = res.data;
      });
    });
    return $scope.myGoBack = function() {
      return $ionicHistory.goBack();
    };
  }]);

}).call(this);

//# sourceMappingURL=post-detail.js.map

(function() {
  'use strict';

  /**
    * @ngdoc function
    * @name frontApp.controller:WritersCtrl
    * @description
    * WritersCtrl
    * Controller of the frontApp
   */
  angular.module("frontApp").controller("WritersCtrl", ["$scope", "$ionicSideMenuDelegate", "Api", "Const", function($scope, $ionicSideMenuDelegate, Api, Const) {
    return $scope.init = function() {
      return Api.getJson("", Const.API.USER + '.json').then(function(res) {
        $scope.users = res.data;
        return $scope.$broadcast('scroll.refreshComplete');
      });
    };
  }]);

}).call(this);

//# sourceMappingURL=writers.js.map

(function() {
  'use strict';

  /**
    * @ngdoc function
    * @name frontApp.controller:WriterDetailCtrl
    * @description
    * WritersCtrl
    * Controller of the frontApp
   */
  angular.module("frontApp").controller("WriterDetailCtrl", ["$scope", "$stateParams", "$ionicModal", "$sessionStorage", "Api", "Const", "toaster", function($scope, $stateParams, $ionicModal, $sessionStorage, Api, Const, toaster) {
    var clearInput;
    $ionicModal.fromTemplateUrl('views/parts/modal-profile-edit.html', {
      scope: $scope,
      animation: 'slide-in-up'
    }).then(function(modalProfileEdit) {
      return $scope.modalProfileEdit = modalProfileEdit;
    });
    $scope.isLoginUser = false;
    clearInput = function() {
      var input;
      input = {
        email: "",
        password: "",
        password_confirmation: ""
      };
      $scope.input = input;
      return angular.forEach(angular.element("input[type='file']"), function(inputElem) {
        return angular.element(inputElem).val(null);
      });
    };
    $scope.writersInit = function() {
      var path;
      clearInput();
      path = Const.API.USER + '/' + $stateParams.id + '.json';
      Api.getJson("", path).then(function(res) {
        $scope.user = res.data.user;
        return $scope.posts = res.data.posts;
      });
      if (String($stateParams.id) === String($sessionStorage['user_id'])) {
        return $scope.isLoginUser = true;
      }
    };
    $scope.openModalProfileEdit = function() {
      var accessKey, path, userId;
      accessKey = {
        email: $sessionStorage['email'],
        token: $sessionStorage['token']
      };
      userId = $sessionStorage['user_id'];
      path = Const.API.USER + '/' + userId + '.json';
      return Api.getJson(accessKey, path).then(function(res) {
        $scope.input = {
          email: res.data.email,
          username: res.data.username,
          first_name: res.data.first_name,
          last_name: res.data.last_name,
          profile: res.data.profile,
          image: res.data.image
        };
        $scope.srcUrl = res.data.image.image.thumb.url;
        return $scope.modalProfileEdit.show();
      });
    };
    $scope.hideModalProfileEdit = function(targetForm) {
      clearInput();
      targetForm.$setPristine();
      return $scope.modalProfileEdit.hide();
    };
    $scope.saveProfile = function(targetForm) {
      var fd, method, url, userId;
      fd = new FormData;
      userId = $sessionStorage['user_id'];
      fd.append('user[id]', userId);
      fd.append('user[username]', $scope.input.username.trim());
      fd.append('user[last_name]', $scope.input.last_name.trim());
      fd.append('user[first_name]', $scope.input.first_name.trim());
      fd.append('user[profile]', $scope.input.profile.trim());
      fd.append('user[image]', $scope.input.file);
      if ($scope.input.file) {
        fd.append('user[image]', $scope.input.file);
      }
      url = Const.API.USER + '/' + userId;
      method = Const.METHOD.PATCH;
      return Api.saveFormData(fd, url, method).then(function(res) {
        clearInput();
        targetForm.$setPristine();
        $scope.modalProfileEdit.hide();
        toaster.pop({
          type: 'success',
          title: 'プロフィールを保存しました',
          showCloseButton: true
        });
        return $scope.writersInit();
      });
    };
    return $scope.$watch('input.file', function(file) {
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
  }]);

}).call(this);

//# sourceMappingURL=writer-detail.js.map

(function() {
  "use strict";
  angular.module("frontApp").factory("Api", ["$http", "$ionicPopup", "$ionicLoading", "toaster", "Const", "config", function($http, $ionicPopup, $ionicLoading, toaster, Const, config) {
    var errorHandring, host;
    host = config.url.api;
    errorHandring = function(data) {
      var alertPopup;
      if (data.error) {
        alertPopup = $ionicPopup.alert({
          title: data.error,
          type: 'button-dark'
        });
        return alertPopup.then(function(res) {});
      } else {
        alertPopup = $ionicPopup.alert({
          title: '通信エラーが発生しました',
          type: 'button-dark'
        });
        return alertPopup.then(function(res) {});
      }
    };
    return {
      getJson: function(obj, path) {
        $ionicLoading.show({
          template: '<ion-spinner icon="ios"></ion-spinner><br>Loading...',
          delay: 500
        });
        return $http({
          method: 'GET',
          url: host + path,
          params: obj
        }).success(function(data, status, headers, config) {
          return $ionicLoading.hide();
        }).error(function(data, status, headers, config) {
          $ionicLoading.hide();
          return errorHandring(data);
        });
      },
      postJson: function(obj, path) {
        $ionicLoading.show({
          template: '<ion-spinner icon="ios"></ion-spinner><br>Loading...',
          delay: 500
        });
        return $http({
          method: 'POST',
          url: host + path,
          data: obj
        }).success(function(data, status, headers, config) {
          return $ionicLoading.hide();
        }).error(function(data, status, headers, config) {
          $ionicLoading.hide();
          return errorHandring(data);
        });
      },
      saveJson: function(obj, path, method) {
        $ionicLoading.show({
          template: '<ion-spinner icon="ios"></ion-spinner><br>Loading...'
        });
        return $http({
          method: method,
          url: host + path + ".json",
          data: obj
        }).success(function(data, status, headers, config) {
          return $ionicLoading.hide();
        }).error(function(data, status, headers, config) {
          $ionicLoading.hide();
          return errorHandring(data);
        });
      },
      saveFormData: function(fd, path, method) {
        $ionicLoading.show({
          template: '<ion-spinner icon="ios"></ion-spinner><br>Loading...'
        });
        return $http({
          method: method,
          url: host + path + ".json",
          transformRequest: null,
          headers: {
            'Content-type': void 0
          },
          data: fd
        }).success(function(data, status, headers, config) {
          return $ionicLoading.hide();
        }).error(function(data, status, headers, config) {
          $ionicLoading.hide();
          return errorHandring(data);
        });
      },
      deleteJson: function(obj, id, path) {
        $ionicLoading.show({
          template: '<ion-spinner icon="ios"></ion-spinner><br>Loading...'
        });
        return $http({
          method: 'DELETE',
          url: host + path + "/" + id + ".json",
          params: obj
        }).success(function(data, status, headers, config) {
          return $ionicLoading.hide();
        }).error(function(data, status, headers, config) {
          $ionicLoading.hide();
          return errorHandring(data);
        });
      },
      logOut: function(obj, path) {
        return $http({
          method: 'DELETE',
          url: host + path,
          params: obj
        }).success(function(data, status, headers, config) {
          return toaster.pop({
            type: 'success',
            title: 'ログアウトしました',
            showCloseButton: true
          });
        }).error(function(data, status, headers, config) {
          return errorHandring(data);
        });
      }
    };
  }]);

}).call(this);

//# sourceMappingURL=api.js.map

(function() {
  "use strict";
  angular.module("frontApp").factory('Const', function() {
    return {
      API: {
        POST: '/posts',
        POST_DETSIL: '/post_details',
        SHOP: '/shops',
        PERSON: '/people/api',
        LOGIN: '/users/sign_in.json',
        LOGOUT: '/authentication_token.json',
        USER: '/users',
        CATEGORY: '/categories.json',
        POST_SHOP: '/posts_shops',
        POST_PERSON: '/people_posts/api'
      },
      MSG: {
        SAVED: '投稿しました',
        DELETED: '削除しました',
        UPDATED: '更新しました',
        LOGED_IN: 'ログインしました',
        SINGED_UP: 'アカウントを作成しました',
        PUBLISHED: '公開しました',
        UNPUBLISHED: '非公開にしました'
      },
      METHOD: {
        POST: 'POST',
        PATCH: 'PATCH'
      },
      URL: {
        GOOGLE_MAP: 'http://maps.google.co.jp/maps?t=m&z=16&q='
      }
    };
  });

}).call(this);

//# sourceMappingURL=const.js.map

(function() {
  "use strict";
  angular.module("frontApp").factory("BaseService", function() {
    return {
      calMapDistance: function(zoom) {
        var clientPx, meterPerPx, targetDistance, targetMeterPerPx;
        meterPerPx = 60;
        targetMeterPerPx = meterPerPx / (zoom - 10);
        clientPx = document.body.clientWidth;
        if (document.body.clientHeight > document.body.clientWidth) {
          clientPx = document.body.clientHeight;
        }
        targetDistance = clientPx * targetMeterPerPx;
        return targetDistance;
      }
    };
  });

}).call(this);

//# sourceMappingURL=base-service.js.map

(function() {
  "use strict";
  angular.module("frontApp").directive('fileModel', ["$parse", function($parse) {
    return {
      restrict: 'A',
      link: function(scope, element, attrs) {
        var model;
        model = $parse(attrs.fileModel);
        return element.bind('change', function() {
          return scope.$apply(function() {
            return model.assign(scope, element[0].files[0]);
          });
        });
      }
    };
  }]).directive('categoryList', function() {
    return {
      restrict: 'A',
      scope: {
        data: '='
      },
      link: function(scope, element, attrs) {
        var text;
        text = [];
        angular.forEach(scope.data, function(cat) {
          return text.push(cat.name);
        });
        return element.append(text.join("・"));
      }
    };
  });

}).call(this);

//# sourceMappingURL=base-directive.js.map

(function() {
  "use strict";
  angular.module("frontApp").filter('newlines', function() {
    return function(text) {
      if (text != null) {
        return text.replace(/\n/g, '<br />');
      }
    };
  }).filter('rekishokuText', function() {
    return function(text) {
      if (text != null) {
        return text.replace('歴食', '<span class="hidden-xs">歴食</span>');
      }
    };
  });

}).call(this);

//# sourceMappingURL=base-filter.js.map

angular.module('frontApp').run(['$templateCache', function($templateCache) {
  'use strict';

  $templateCache.put('views/aside.html',
    "<ion-content class=\"aside\"> <aside> <nav class=\"grid-menu\"> <a href=\"\"><i class=\"fa fa-search\"></i>検索</a> <a href=\"\"><i class=\"fa fa-calendar\"></i>カレンダー</a> <a href=\"\"><i class=\"fa fa-envelope\"></i>メール</a> <a href=\"\"><i class=\"fa fa-cog\"></i>機能</a> <a href=\"\"><i class=\"fa fa-list\"></i>一覧</a> <a href=\"\"><i class=\"fa fa-shopping-cart\"></i>カート</a> <a href=\"\"><i class=\"fa fa-smile-o\"></i>お気に入り</a> <a href=\"\"><i class=\"fa fa-camera-retro\"></i>ギャラリー</a> <a href=\"\"><i class=\"fa fa-location-arrow\"></i>店舗アクセス</a> <a href=\"\"><i class=\"fa fa-book\"></i>E-Book</a> <a href=\"\"><i class=\"fa fa-comments-o\"></i>Contact</a> <a href=\"\"><i class=\"fa fa-question-circle\"></i>FAQ</a> </nav> <nav class=\"list-menu\"> <ul> <li><a href=\"\">カテゴリ１</a></li> <li><a href=\"\">カテゴリ２</a></li> <li><a href=\"\">カテゴリ３</a></li> <li><a href=\"\">カテゴリ４</a></li> </ul> </nav> </aside> </ion-content>"
  );


  $templateCache.put('views/main.html',
    "<ion-refresher pulling-text=\"Pull to refresh...\" on-refresh=\"init()\"> </ion-refresher> <div class=\"row\"> <div class=\"col main-category\"> <div class=\"button-bar\"> <a class=\"button\" ng-repeat=\"category in categories\" ng-click=\"search({{category.id}})\" ng-bind-html=\"category.name | rekishokuText\" ng-class=\"{active: targetCategoryId == category.id}\"></a> </div> </div> </div> <div class=\"main\"> <ul class=\"item-list\"> <li class=\"overlay-image\" ng-repeat=\"post in posts\"> <div class=\"thumbnail-image\"> <img ng-src=\"{{post.image.md.url}}\"> </div> <div class=\"main-content\"> <div> <div class=\"category-name\">{{post.category_name}}</div> <div class=\"h4 item-name\">{{post.title}}</div> <div class=\"h6 post-date\"><i class=\"icon ion-ios-clock-outline\"></i>{{post.created_at | date:'yyyy/M/d'}}</div> </div> </div> <a class=\"link\" ui-sref=\"post({id:post.id})\"></a> </li> </ul> </div> <ion-infinite-scroll ng-if=\"!noMoreLoad\" on-infinite=\"loadMoreData()\"> </ion-infinite-scroll>"
  );


  $templateCache.put('views/map.html',
    "<ui-gmap-google-map center=\"map.center\" zoom=\"map.zoom\" draggable=\"true\" options=\"options\" bounds=\"map.bounds\" events=\"events\"> <ui-gmap-markers models=\"targetMarkers\" coords=\"'self'\" icon=\"'icon'\" clusterevents=\"clickEventsObject\" click=\"clickMarker\"> <ui-gmap-windows show=\"show\"> <div ng-non-bindable class=\"gmap-windows\"> <h4>{{title}}</h4> <a class=\"link\" href=\"#/shop/{{id}}\"><img src=\"{{url}}\"></a> </div> </ui-gmap-windows> </ui-gmap-markers> </ui-gmap-google-map>"
  );


  $templateCache.put('views/menu.html',
    "<ion-side-menus> <!-- Left menu --> <ion-side-menu side=\"right\" ng-controller=\"HeaderCtrl\"> <div class=\"list menu-list\"> <div class=\"item item-divider\">Menu</div> <a class=\"item item-icon-right\" ng-click=\"closeMenu()\" ui-sref=\"home\" nav-transition=\"none\"> ホーム <i class=\"icon ion-chevron-right\"></i> </a> <a class=\"item item-icon-right\" ng-click=\"closeMenu()\" ui-sref=\"writers\" nav-transition=\"none\"> ライター一覧 <i class=\"icon ion-chevron-right\"></i> </a> <a class=\"item item-icon-right\" ng-click=\"closeMenu()\" ui-sref=\"my-post\" nav-transition=\"none\" ng-if=\"isLogin\"> 投稿一覧 <i class=\"icon ion-chevron-right\"></i> </a> <div class=\"item item-divider\" ng-show=\"showLogin\">My Account</div> <a class=\"item item-icon-right\" ng-click=\"moveToWriterDetail()\" ng-show=\"isLogin\"> プロフィール <i class=\"icon ion-chevron-right\"></i> </a> <a class=\"item\" ng-click=\"openModalLogin()\" ng-show=\"!isLogin && showLogin\">ログイン</a> <a class=\"item\" ng-click=\"doLogout()\" ng-show=\"isLogin\">ログアウト</a> </div> </ion-side-menu> <ion-side-menu-content animation=\"slide-left-right\" nav-transition=\"ios\"> <ion-nav-bar class=\"header\" animation=\"slide-left-right\" nav-transition=\"ios\"> <div class=\"bar bar-header top\"> <h1 class=\"title hidden\">歴食</h1> <div class=\"logo\"></div> </div> <nav class=\"fix-nav\" ng-controller=\"HeaderCtrl\"> <a href=\"\" ng-click=\"toggleRight()\"><i class=\"icon ion-navicon-round\"></i></a> </nav> <ion-nav-back-button class=\"button-back\"> <i class=\"ion-chevron-left\"></i> Back </ion-nav-back-button> <!-- <div ng-include=\"'views/aside.html'\"></div> --> </ion-nav-bar> <ion-nav-view animation=\"slide-left-right\"></ion-nav-view> </ion-side-menu-content> </ion-side-menus>"
  );


  $templateCache.put('views/parts/modal-login.html',
    "<ion-modal-view> <ion-header-bar class=\"bar-dark\"> <div class=\"buttons\"> <button class=\"button icon ion-close-round\" ng-click=\"hideModalLogin()\"></button> </div> <h1 class=\"title\">ログイン</h1> </ion-header-bar> <ion-content> <div class=\"list\"> <label class=\"item item-input\"> <span class=\"input-label\">メールアドレス</span> <input type=\"text\" ng-model=\"input.email\"> </label> <label class=\"item item-input\"> <span class=\"input-label\">パスワード</span> <input type=\"password\" ng-model=\"input.password\"> </label> <label class=\"item item-input\"> <span class=\"input-label\">パスワード再入力</span> <input type=\"password\" ng-model=\"input.password_confirmation\"> </label> </div> <div class=\"padding\"> <button class=\"button button-block button-positive\" ng-click=\"doLogin()\">ログイン</button> <button class=\"button button-block button-positive\" ng-click=\"doSignUp()\">アカウント作成</button> </div> </ion-content> </ion-modal-view>"
  );


  $templateCache.put('views/parts/modal-people.html',
    "<ion-modal-view> <!-- header --> <ion-header-bar class=\"bar-dark\"> <div class=\"buttons\"> <button class=\"button icon ion-close-round\" ng-click=\"closeModalPeople()\"></button> </div> <h1 class=\"title\">人物一覧</h1> <div class=\"buttons\" ng-click=\"savePeople()\"> <button class=\"button\">保存する</button> </div> </ion-header-bar> <!-- subheader --> <div class=\"bar bar-subheader-modal bar-clear edit-menu\" align=\"right\"> <label class=\"item item-input\"> <i class=\"icon ion-search placeholder-icon\"></i> <input type=\"text\" placeholder=\"Search\" ng-model=\"search.name\"> </label> </div> <ion-content class=\"has-subheader\"> <div class=\"list\"> <div class=\"item item-button-left\" ng-repeat=\"person in people | filter:search\" ng-click=\"person.checked = !person.checked\"> <button class=\"button icon ion-checkmark-round checkbox\" ng-class=\"{active: person.checked}\"></button> {{person.name}} </div> </div> </ion-content> </ion-modal-view>"
  );


  $templateCache.put('views/parts/modal-post.html',
    "<ion-modal-view class=\"big-modal\"> <!-- ヘッダー --> <ion-header-bar class=\"bar-dark\"> <div class=\"buttons\" ng-click=\"closeModalPost(postForm)\"> <button class=\"button icon ion-close-round\"></button> </div> <h1 class=\"title\"> <span ng-if=\"!isEditing\">新規投稿</span> <span ng-if=\"isEditing\">投稿編集</span> </h1> <div class=\"buttons\" ng-click=\"doPost(postForm)\"> <button class=\"button\">保存する</button> </div> </ion-header-bar> <form name=\"postForm\" class=\"post-modal\"> <ion-slide-box> <!-- メイン投稿 --> <ion-slide> <ion-content> <div class=\"list\"> <div class=\"item\"> <div class=\"button-bar\"> <a class=\"button\" ng-repeat=\"category in categories\" ng-model=\"category\" ng-class=\"{active: category.checked}\" ng-click=\"checkCategory(category.id)\" ng-bind-html=\"category.name | rekishokuText\"></a> </div> </div> <label class=\"item item-input-inset item-stacked-label-xs\"> <span class=\"input-label\">タイトル</span> <input class=\"item-input-wrapper\" type=\"text\" ng-model=\"input.title\"> </label> <div class=\"item item-input item-thumbnail-right\" href=\"#\"> <img class=\"uploaded-img\" ng-if=\"srcUrl\" ng-src=\"{{srcUrl}}\"> <span class=\"input-label\">メイン画像</span> <div class=\"file\"> ファイルを選択 <input type=\"file\" file-model=\"input.file\"> </div> </div> <label class=\"item item-input-inset item-stacked-label-xs\"> <span class=\"input-label\">本文</span> <textarea class=\"item-input-wrapper\" rows=\"8\" ng-model=\"input.content\"></textarea> </label> <label class=\"item item-input-inset item-stacked-label-xs\"> <span class=\"input-label\">引用元名</span> <input class=\"item-input-wrapper\" type=\"text\" ng-model=\"input.quotationName\"> </label> <label class=\"item item-input-inset item-stacked-label-xs\"> <span class=\"input-label\">引用元URL</span> <input class=\"item-input-wrapper\" type=\"text\" ng-model=\"input.quotationUrl\"> </label> </div> </ion-content> </ion-slide> <ion-slide ng-repeat=\"detail in input.details\"> <ion-content> <div class=\"list\"> <label class=\"item item-input-inset item-stacked-label-xs\" ng-hide=\"targetCategorySlug=='experience'\"> <span class=\"input-label\">サブタイトル{{detail.index}}</span> <input class=\"item-input-wrapper\" type=\"text\" ng-model=\"detail.subTitle\"> </label> <div class=\"item item-input item-thumbnail-right\" href=\"#\"> <img class=\"uploaded-img\" ng-if=\"detail.srcSubUrl\" ng-src=\"{{detail.srcSubUrl}}\"> <span class=\"input-label\">サブ画像{{detail.index}}</span> <div class=\"file\"> ファイルを選択 <input type=\"file\" file-model=\"detail.subFile\"> </div> </div> <label class=\"item item-input-inset item-stacked-label-xs\"> <span class=\"input-label\">サブ本文{{detail.index}}</span> <textarea class=\"item-input-wrapper\" rows=\"8\" ng-model=\"detail.subContent\"></textarea> </label> <label class=\"item item-input-inset item-stacked-label-xs\" ng-hide=\"targetCategorySlug=='experience'\"> <span class=\"input-label\">引用元名</span> <input class=\"item-input-wrapper\" type=\"text\" ng-model=\"detail.subQuotationName\"> </label> <label class=\"item item-input-inset item-stacked-label-xs\" ng-hide=\"targetCategorySlug=='experience'\"> <span class=\"input-label\">引用元URL</span> <input class=\"item-input-wrapper\" type=\"text\" ng-model=\"detail.subQuotationUrl\"> </label> </div> </ion-content> </ion-slide> </ion-slide-box> </form> <!-- フッター --> <ion-footer-bar align-title=\"left\" class=\"bar-stable\"> <button class=\"button icon-left ion-chevron-left\" ng-click=\"backSlide()\" ng-show=\"isShowBackSlide\">戻る</button> <h1 class=\"title\"></h1> <button class=\"button icon-right ion-chevron-right\" ng-click=\"prevSlide()\" ng-show=\"isShowAddPostDetail\">追加項目</button> </ion-footer-bar> </ion-modal-view>"
  );


  $templateCache.put('views/parts/modal-profile-edit.html',
    "<ion-modal-view class=\"big-modal\"> <!-- ヘッダー --> <ion-header-bar class=\"bar-dark\"> <div class=\"buttons\" ng-click=\"hideModalProfileEdit(profileForm)\"> <button class=\"button icon ion-close-round\"></button> </div> <h1 class=\"title\"> <span>プロフィール</span> </h1> <div class=\"buttons\" ng-click=\"saveProfile(profileForm)\"> <button class=\"button\">保存する</button> </div> </ion-header-bar> <form name=\"profileForm\" class=\"post-modal\"> <ion-content> <div class=\"list\"> <label class=\"item item-input-inset item-stacked-label-xs\"> <span class=\"input-label\">メールアドレス</span> <input class=\"item-input-wrapper\" type=\"text\" ng-model=\"input.email\" readonly> </label> <label class=\"item item-input-inset item-stacked-label-xs\"> <span class=\"input-label\">ユーザー名</span> <input class=\"item-input-wrapper\" type=\"text\" ng-model=\"input.username\"> </label> <label class=\"item item-input-inset item-stacked-label-xs\"> <span class=\"input-label\">名字</span> <input class=\"item-input-wrapper\" type=\"text\" ng-model=\"input.last_name\"> </label> <label class=\"item item-input-inset item-stacked-label-xs\"> <span class=\"input-label\">名前</span> <input class=\"item-input-wrapper\" type=\"text\" ng-model=\"input.first_name\"> </label> <div class=\"item item-input item-thumbnail-right\" href=\"#\"> <img class=\"uploaded-img\" ng-if=\"srcUrl\" ng-src=\"{{srcUrl}}\"> <span class=\"input-label\">プロフィール画像</span> <div class=\"file\"> ファイルを選択 <input type=\"file\" file-model=\"input.file\"> </div> </div> <label class=\"item item-input-inset item-stacked-label-xs\"> <span class=\"input-label\">自己紹介</span> <textarea class=\"item-input-wrapper\" rows=\"8\" ng-model=\"input.profile\"></textarea> </label> </div> </ion-content> </form> </ion-modal-view>"
  );


  $templateCache.put('views/parts/modal-shops.html',
    "<ion-modal-view> <!-- header --> <ion-header-bar class=\"bar-dark\"> <div class=\"buttons\"> <button class=\"button icon ion-close-round\" ng-click=\"closeModalShops()\"></button> </div> <h1 class=\"title\">ショップ一覧</h1> <div class=\"buttons\" ng-click=\"saveShops()\"> <button class=\"button\">保存する</button> </div> </ion-header-bar> <!-- subheader --> <div class=\"bar bar-subheader-modal bar-clear edit-menu\" align=\"right\"> <label class=\"item item-input\"> <i class=\"icon ion-search placeholder-icon\"></i> <input type=\"text\" placeholder=\"Search\" ng-model=\"search.name\"> </label> </div> <ion-content class=\"has-subheader\"> <div class=\"list\"> <div class=\"item item-button-left\" ng-repeat=\"shop in shops | filter:search\" ng-click=\"shop.checked = !shop.checked\"> <button class=\"button icon ion-checkmark-round checkbox\" ng-class=\"{active: shop.checked}\"></button> {{shop.name}} </div> </div> </ion-content> </ion-modal-view>"
  );


  $templateCache.put('views/parts/popover-post-menu.html',
    "<ion-popover-view> <ion-header-bar class=\"bar-dark\"> <div class=\"buttons\"> <button class=\"button icon ion-close-round\" ng-click=\"closePopoverPostMenu()\"></button> </div> <h1 class=\"title\">メニュー</h1> </ion-header-bar> <ion-content> <ul class=\"list\"> <a class=\"item item-icon-left\" ng-click=\"onEditButton(targetIndex);\"> <i class=\"icon ion-compose\"></i> 編集する </a> <a class=\"item item-icon-left\" ng-click=\"openModalShops();\"> <i class=\"icon ion-plus-circled\"></i> 関連店舗を登録する </a> <a class=\"item item-icon-left\" ng-click=\"openModalPeople();\"> <i class=\"icon ion-plus-circled\"></i> 関連人物を登録する </a> <a class=\"item item-icon-left\" ng-click=\"updateStatus(1);\" ng-if=\"targetStatus==0\"> <i class=\"icon ion-share\"></i> 公開する </a> <a class=\"item item-icon-left\" ng-click=\"updateStatus(0);\" ng-if=\"targetStatus==1\"> <i class=\"icon ion-close-round\"></i> 非公開にする </a> </ul> </ion-content> </ion-popover-view>"
  );


  $templateCache.put('views/post-detail.html',
    "<ion-view title=\"\"> <ion-content has-header=\"true\" class=\"padding-top\"> <div class=\"row\"> <div class=\"col-xs-12 col-sm-8 col-sm-offset-2 col-md-6 col-md-offset-3\"> <div class=\"post-title\"> <h1>{{post.title}}</h1> <p class=\"category\" ng-if=\"post.category_name\">{{post.category_name}}</p> <p class=\"date\">{{post.created_at | date:'yyyy/M/d'}}</p> </div> <div class=\"detail-image\"><img ng-src=\"{{post.image.url}}\"></div> <div class=\"post-quotation\" ng-if=\"post.quotation_name\">掲載元：<a href=\"{{post.quotation_url}}\" target=\"_blank\">{{post.quotation_name}}</a></div> <div class=\"post-content\" ng-if=\"post.content\"><p ng-bind-html=\"post.content | newlines\"></p></div> </div> </div> <div class=\"row\" ng-repeat=\"postDetail in postDetails\"> <div class=\"col-xs-12 col-sm-8 col-sm-offset-2 col-md-6 col-md-offset-3\"> <div class=\"post-title\" ng-if=\"postDetail.title\"><h3 class=\"sub\">{{postDetail.title}}</h3></div> <div class=\"detail-image\" ng-if=\"postDetail.image.url\"><img ng-src=\"{{postDetail.image.url}}\"></div> <div class=\"post-quotation\" ng-if=\"postDetail.quotation_name\">掲載元：<a href=\"{{postDetail.quotation_url}}\" target=\"_blank\">{{postDetail.quotation_name}}</a></div> <div class=\"post-content\" ng-if=\"postDetail.content\"><p ng-bind-html=\"postDetail.content | newlines\"></p></div> </div> </div> <div class=\"row row-top\" ng-if=\"shops.length!=0\"> <div class=\"col-xs-12 col-sm-8 col-sm-offset-2 col-md-6 col-md-offset-3\"> <div class=\"reki-icon\"><h2>店舗情報</h2></div> </div> </div> <div class=\"row post-shops row-bottom\" ng-if=\"shops.length!=0\"> <div class=\"col-xs-12 col-sm-8 col-sm-offset-2 col-md-6 col-md-offset-3\"> <ul class=\"item-detail-list\"> <li class=\"overlay-image\" ng-repeat=\"shop in shops\"> <div class=\"thumbnail-image\"> <img ng-src=\"{{shop.shop.image.md.url}}\"> </div> <div class=\"detail-content\"> <div> <div class=\"category-name shop-category\" category-list data=\"shop.categories\"></div> <div class=\"h4 detail-name\">{{shop.shop.name}}</div> <div class=\"h6 item-description hidden-xs\">{{shop.shop.description | limitTo:300}}</div> <div class=\"item-address\" ng-if=\"shop.shop.address1\">{{shop.shop.province}}</div> <div class=\"item-address\" ng-if=\"!shop.shop.address1\">-</div> </div> </div> <a class=\"link\" ui-sref=\"shop({id:shop.shop.id})\"></a> </li> </ul> </div> </div> </ion-content> </ion-view>"
  );


  $templateCache.put('views/post-list.html',
    "<ion-view title=\"\" ng-init=\"init()\"> <ion-nav-bar class=\"header\" animation=\"slide-left-right\" nav-transition=\"ios\"> <div class=\"bar bar-header top\"> <h1 class=\"title hidden\">歴食</h1> <div class=\"logo\"></div> </div> <nav class=\"fix-nav\" ng-controller=\"HeaderCtrl\"> <a href=\"\" ng-click=\"toggleRight()\"><i class=\"icon ion-navicon-round\"></i></a> </nav> </ion-nav-bar> <div class=\"bar bar-subheader bar-clear edit-menu\" align=\"right\"> <button class=\"button button-assertive icon-left ion-trash-a\" ng-click=\"doDelete()\" ng-if=\"showDeleteButton\">削除</button> <button class=\"button button-dark icon-left ion-plus-round\" ng-click=\"openModalPost()\" ng-if=\"!showDeleteButton\" ng-show=\"isLogin\">新規投稿</button> </div> <ion-content class=\"has-subheader\"> <ion-refresher pulling-text=\"Pull to refresh...\" on-refresh=\"init()\"> </ion-refresher> <table class=\"table table-striped item-table\"> <thead> <tr> <th class=\"\"></th> <th class=\"post-title\">タイトル</th> <th class=\"post-content hidden-xs\">本文</th> <th class=\"post-category hidden-xs\">カテゴリー</th> <th class=\"delete-button\"></th> </tr> </thead> <tbody> <tr ng-repeat=\"result in results\"> <td class=\"vertical-align\"> <button class=\"button icon ion-checkmark-round checkbox\" ng-class=\"{active: result.checked}\" ng-click=\"onCheckbox(result)\"></button> </td> <td>{{result.title}}</td> <td class=\"hidden-xs\">{{result.content | limitTo:100}}...</td> <td class=\"hidden-xs\">{{result.category_name}}</td> <td align=\"right\"> <button class=\"button button-dark\" ng-click=\"openPopoverPostMenu($event, $index)\"><i class=\"icon ion-android-more-vertical\"></i></button> </td> </tr> </tbody> </table> </ion-content> </ion-view>"
  );


  $templateCache.put('views/shop-detail.html',
    "<ion-view title=\"\"> <ion-content has-header=\"true\" class=\"padding-top\"> <div class=\"row row-bottom\"> <div class=\"col-xs-12 col-sm-8 col-sm-offset-2 col-md-6 col-md-offset-3\"> <div class=\"post-title\"> <h1>{{shop.name}}</h1> <p class=\"category\" ng-if=\"categories\" category-list data=\"categories\"></p> <a target=\"_blank\" href=\"http://maps.google.co.jp/maps?t=m&z=16&q={{shop.address1}}\"><i class=\"icon ion-ios-location\"></i>{{shop.province + shop.city + shop.address1 + shop.address2}}</a> </div> <div class=\"detail-image\"><img ng-src=\"{{shop.image.url}}\"></div> <div class=\"post-quotation\" ng-if=\"shop.image_quotation_name\">掲載元：<a href=\"{{shop.image_quotation_url}}\" target=\"_blank\">{{shop.quotation_name}}</a></div> <div class=\"shop-content\" ng-if=\"shop.description\"><p ng-bind-html=\"shop.description | newlines\"></p></div> </div> </div> <div class=\"row row-top row-bottom bg-gray\"> <div class=\"col-xs-12 col-sm-8 col-sm-offset-2 col-md-6 col-md-offset-3\"> <div class=\"detail-image\"><img ng-src=\"{{shop.subimage.url}}\"></div> <div class=\"shop-info\"> <div class=\"shop-info-row\"> <div class=\"shop-info-col\">店舗名</div> <div>{{shop.name}}</div> </div> <div class=\"shop-info-row\"> <div class=\"shop-info-col\">URL</div> <div><a href=\"{{shop.url}}\" target=\"_blank\">{{shop.url}}</a></div> </div> <div class=\"shop-info-row\"> <div class=\"shop-info-col\">所在地</div> <div> <a target=\"_blank\" href=\"http://maps.google.co.jp/maps?t=m&z=16&q={{shop.address1}}\"> {{shop.province + shop.city + shop.address1 + shop.address2}} </a> </div> </div> <div class=\"shop-info-row\"> <div class=\"shop-info-col\">MENU</div> <div ng-bind-html=\"shop.menu | newlines\"></div> </div> </div> <div class=\"detail-map\"> <ui-gmap-google-map center=\"map.center\" zoom=\"map.zoom\" draggable=\"true\" options=\"options\" bounds=\"map.bounds\"> <ui-gmap-markers models=\"targetMarkers\" coords=\"'self'\" icon=\"'icon'\"> </ui-gmap-markers> </ui-gmap-google-map> </div> </div> </div> <div class=\"row row-top\" ng-if=\"posts.length!=0\"> <div class=\"col-xs-12 col-sm-8 col-sm-offset-2 col-md-6 col-md-offset-3\"> <div class=\"reki-icon\"><h2>歴食体験・エピソード</h2></div> </div> </div> <div class=\"row post-shops row-bottom\" ng-if=\"shops.length!=0\"> <div class=\"col-xs-12 col-sm-8 col-sm-offset-2 col-md-6 col-md-offset-3\"> <ul class=\"item-detail-list\"> <li class=\"overlay-image\" ng-repeat=\"post in posts\"> <div class=\"thumbnail-image\"> <img ng-src=\"{{post.image.md.url}}\"> </div> <div class=\"detail-content\"> <div> <div class=\"category-name\">{{post.category_name}}</div> <div class=\"h4 detail-name\">{{post.title}}</div> <div class=\"h6 item-description hidden-xs\">{{post.content | limitTo:300}}</div> <div class=\"h6 post-date\"><i class=\"icon ion-ios-clock-outline\"></i>{{post.created_at | date:'yyyy/M/d'}}</div> </div> </div> <a class=\"link\" ui-sref=\"post({id:post.id})\"></a> </li> </ul> </div> </div></ion-content> </ion-view>"
  );


  $templateCache.put('views/shops.html',
    "<ion-refresher pulling-text=\"Pull to refresh...\" on-refresh=\"init()\"> </ion-refresher> <div class=\"row\"> <div class=\"col main-category\"> <div class=\"button-bar\"> <a class=\"button\" ng-repeat=\"category in categories\" ng-click=\"search({{category.id}})\" ng-bind-html=\"category.name\" ng-class=\"{active: targetCategoryId == category.id}\"></a> </div> </div> </div> <div class=\"main\"> <ul class=\"item-list\"> <li class=\"overlay-image\" ng-repeat=\"result in results\"> <div class=\"thumbnail-image\"> <img ng-src=\"{{result.shop.image.md.url}}\"> </div> <div class=\"shop-content\"> <div> <div class=\"category-name\" category-list data=\"result.categories\"></div> <div class=\"h4 item-name\">{{result.shop.name}}</div> <div class=\"item-address\" ng-if=\"result.shop.address1\">{{result.shop.province}}</div> <div class=\"item-address\" ng-if=\"!result.shop.address1\">-</div> </div> </div> <a class=\"link\" ui-sref=\"shop({id:result.shop.id})\"></a> </li> </ul> </div> <ion-infinite-scroll ng-if=\"!noMoreLoad\" on-infinite=\"loadMoreData()\"> </ion-infinite-scroll>"
  );


  $templateCache.put('views/tabs.html',
    "<ion-view title=\"\"> <ion-nav-bar class=\"header tab-header\" animation=\"slide-left-right\" nav-transition=\"ios\"> <div class=\"bar bar-header top\"> <h1 class=\"title hidden\">歴食</h1> <div class=\"logo\"></div> </div> <nav class=\"fix-nav\" ng-controller=\"HeaderCtrl\"> <a href=\"\" ng-click=\"toggleRight()\"><i class=\"icon ion-navicon-round\"></i></a> </nav> </ion-nav-bar> <ion-tabs class=\"tabs-icon-top tabs-color-light\" animation=\"slide-left-right\" nav-transition=\"ios\"> <!-- Main  --> <ion-tab title=\"STORY\" icon=\"ion-ios-list-outline\" ng-controller=\"MainCtrl\"> <ion-content ng-init=\"init()\"> <div ng-include=\"'views/main.html'\"></div> </ion-content> </ion-tab> <!-- Map  --> <ion-tab title=\"MAP\" icon=\"ion-ios-navigate-outline\" ng-controller=\"MapCtrl\"> <!-- Serach bar --> <div class=\"bar bar-subheader bar-clear\" align=\"right\"> <button class=\"button button-clear icon-left ion-ios-location present-location\" ng-click=\"init()\"><span>現在地</span></button> <div class=\"item-input-inset search-bar\"> <label class=\"item-input-wrapper\"> <input type=\"text\" placeholder=\"住所\" ng-model=\"input.address\"> </label> <button class=\"button button-small button-dark\" ng-click=\"searchShops()\">検索</button> </div> </div> <!-- Google map --> <ion-content class=\"has-subheader maps\" ng-init=\"init()\" scroll=\"false\"> <div class=\"map-include\" ng-include=\"'views/map.html'\"></div> </ion-content> </ion-tab> <!-- Shops  --> <ion-tab title=\"FOOD\" icon=\"ion-android-restaurant\" ng-controller=\"ShopsCtrl\"> <ion-content ng-init=\"init()\"> <div ng-include=\"'views/shops.html'\"></div> </ion-content> </ion-tab> </ion-tabs> </ion-view> <script type=\"text/ng-template\"></script>"
  );


  $templateCache.put('views/writer-detail.html',
    "<ion-view title=\"\" ng-init=\"writersInit()\"> <div class=\"bar bar-subheader edit-menu\" align=\"right\"> <button class=\"button button-dark icon-left ion-edit\" ng-click=\"openModalProfileEdit()\" ng-if=\"isLoginUser\">編集</button> </div> <ion-content class=\"\"> <div class=\"main\"> <div class=\"row bg-gray padding-content\"> <div class=\"col-xs-12 col-sm-4 col-sm-offset-0 col-md-2\"> <div class=\"thumbnail-writer-image\"> <img ng-src=\"{{user.image.image.thumb.url}}\"> </div> </div> <div class=\"col-xs-12 col-sm-8 col-md-6\"> <div class=\"profile\"> <h3>{{user.username}}</h3> <p ng-bind-html=\"user.profile | newlines\"></p> </div> </div> </div> <div class=\"row list-title\" ng-if=\"posts\"> <div class=\"col-md-12\"> <div class=\"reki-icon\"><h2>投稿一覧</h2></div> </div> </div> </div> <div class=\"main\" ng-if=\"posts\"> <ul class=\"item-list\"> <li class=\"overlay-image\" ng-repeat=\"post in posts\"> <div class=\"thumbnail-image\"> <img ng-src=\"{{post.image.md.url}}\"> </div> <div class=\"main-content\"> <div> <div class=\"category-name\">{{post.category_name}}</div> <div class=\"h4 item-name\">{{post.title}}</div> <div class=\"h6 post-date\"><i class=\"icon ion-ios-clock-outline\"></i>{{post.created_at | date:'yyyy/M/d'}}</div> </div> </div> <a class=\"link\" ui-sref=\"post({id:post.id})\"></a> </li> </ul> </div> </ion-content> </ion-view>"
  );


  $templateCache.put('views/writers.html',
    "<ion-view title=\"\" ng-init=\"init()\"> <ion-nav-bar class=\"header\" animation=\"slide-left-right\" nav-transition=\"ios\"> <div class=\"bar bar-header top\"> <h1 class=\"title hidden\">歴食</h1> <div class=\"logo\"></div> </div> <nav class=\"fix-nav\" ng-controller=\"HeaderCtrl\"> <a href=\"\" ng-click=\"toggleRight()\"><i class=\"icon ion-navicon-round\"></i></a> </nav> </ion-nav-bar> <ion-content class=\"padding-top\"> <ion-refresher pulling-text=\"Pull to refresh...\" on-refresh=\"init()\"> </ion-refresher> <div class=\"main padding-top\"> <ul class=\"item-list\"> <li class=\"overlay-image\" ng-repeat=\"user in users\"> <div class=\"thumbnail-image\"> <img ng-src=\"{{user.image.image.md.url}}\"> </div> <div class=\"writer-content\"> <div> <div class=\"h4 item-username\">{{user.username}}</div> <div class=\"h6 item-profile visible-xs\">{{user.profile}}</div> </div> </div> <a class=\"link\" ui-sref=\"writer({id:user.id})\"></a> </li> </ul> </div> </ion-content> </ion-view>"
  );

}]);
