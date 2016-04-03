"use strict"

angular.module "frontApp"
  #改行コードをBRタグへ変換する
  .filter 'newlines', () ->
    (text) -> text.replace(/\n/g, '<br />') if text?

  #歴食の文言にspanタグを追加する
  .filter 'rekishokuText', () ->
    (text) -> text.replace('歴食', '<span class="hidden-xs">歴食</span>') if text?

  #オブジェクトからidに紐づくデータを抽出する
  .filter 'mapppingId', () ->
    (id, objs) ->
      targert = undefined
      angular.forEach objs, (obj) ->
        if obj.id == id
          targert = obj.name
      return targert
