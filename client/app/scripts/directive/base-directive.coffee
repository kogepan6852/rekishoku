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
  # 人物が複数の場合、1つめの要素+「等」を返却する
  .directive 'peopleList', ->
    return {
      restrict: 'A'
      scope:
        data: '='
      link: (scope, element, attrs) ->
        text = []
        angular.forEach scope.data, (cat) ->
          text.push(cat.name)
        if text.length == 1
          rtnText = text[0]
        else
          rtnText = text[0] + "<span class='small'>等</span>"
        element.append(rtnText)
    }
