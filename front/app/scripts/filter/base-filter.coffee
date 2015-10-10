"use strict"

angular.module "frontApp"
  .filter 'newlines', ($sce) ->
    (text) -> text.replace(/\n/g, '<br />') if text?
