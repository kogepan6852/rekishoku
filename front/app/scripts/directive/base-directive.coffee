"use strict"

angular.module "frontApp"
  # ファイルをアップロード用
  .directive 'fileModel', ($parse) ->
    return {
      restrict: 'A'
      link: (scope, element, attrs) ->
        model = $parse(attrs.fileModel)
        element.bind 'change', ->
          scope.$apply ->
            model.assign scope, element[0].files[0]
    }
  # カテゴリを「・」で区切ったリストにする
  .directive 'categoryList', ->
    return {
      restrict: 'A'
      scope:
        data: '='
      link: (scope, element, attrs) ->
        text = []
        angular.forEach scope.data, (cat) ->
          text.push(cat.name)
        element.append(text.join("・"));
    }
