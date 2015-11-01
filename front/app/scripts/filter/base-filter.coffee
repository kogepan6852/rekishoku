"use strict"

angular.module "frontApp"
  #改行コードをBRタグへ変換する
  .filter 'newlines', ($sce) ->
    (text) -> text.replace(/\n/g, '<br />') if text?
  #歴食の文言にspanタグを追加する
  .filter 'rekishokuText', ($sce) ->
    (text) -> text.replace('歴食', '<span class="hidden-xs">歴食</span>') if text?
