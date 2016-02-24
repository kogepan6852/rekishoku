# 店舗と人物の登録画面の入力欄　ここから
(($) ->

  $.fn.floatLabels = (options) ->
    # Settings
    self = this
    settings = $.extend({}, options)
    # Actions
    actions =
      initialize: ->
        self.each ->
          $this = $(this)
          $label = $this.children('label')
          $field = $this.find('input,textarea').first()
          if $this.children().first().is('label')
            $this.children().first().remove()
            $this.append $label
          placeholderText = if $field.attr('placeholder') and $field.attr('placeholder') != $label.text() then $field.attr('placeholder') else $label.text()
          $label.data 'placeholder-text', placeholderText
          $label.data 'original-text', $label.text()
          if $field.val() == ''
            $field.addClass 'empty'
          return
        return
      swapLabels: (field) ->
        $field = $(field)
        $label = $(field).siblings('label').first()
        isEmpty = Boolean($field.val())
        if isEmpty
          $field.removeClass 'empty'
          $label.text $label.data('original-text')
        else
          $field.addClass 'empty'
          $label.text $label.data('placeholder-text')
        return
    # Event Handlers

    registerEventHandlers = ->
      self.on 'input keyup change', 'input, textarea', ->
        actions.swapLabels this
        return
      return

    # Initialization

    init = ->
      registerEventHandlers()
      actions.initialize()
      self.each ->
        actions.swapLabels $(this).find('input,textarea').first()
        return
      return

    init()
    this

  $ ->
    $('.float-label-control').floatLabels()
    return
  return
) jQuery

# 店舗と人物の登録画面の入力欄 ここまで
