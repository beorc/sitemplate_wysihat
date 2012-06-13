window.SITEMPLATE = {} unless window.SITEMPLATE
SITEMPLATE.lib = {} unless SITEMPLATE.lib
window.SITEMPLATE.lib.wysihat = {} unless window.SITEMPLATE.lib.wysihat

window.SITEMPLATE.lib.wysihat.handler =
  EditorHandler: class 
    constructor: (editor, cfg) ->
      self = @
      @textarea = editor
      @editor = WysiHat.Editor.attach($(editor))
      @editor.handler = self
      self.cfg = cfg
      @load()

      @editor.addClass 'clearfix'

      toolbar = new WysiHat.Toolbar()
      toolbar.initialize(@editor)

      @toolbar = @editor.prevAll('.editor_toolbar:first')
      @toolbar.addClass 'btn-toolbar'

      for name, button of cfg.buttons
        toolbar.addButton button if button
        if button.init
          button.init @toolbar.children('.button:last')

      for name, dropdown of cfg.dropdowns
        toolbar.addDropdown dropdown if dropdown

      @toolbar_placeholder = $('<div/>').
        addClass('placeholder').
        css {
          height: @toolbar.height()
        }

      @editor.before @toolbar_placeholder
      @toolbar.appendTo @toolbar_placeholder

      @editor.parents('form:first').submit () =>
        @save()

      # Handlers

      $(window).bind "scroll", (event) =>
        @scrollHandler(event)

      @editor.on 'click', '*', () ->
        self.editor.find('.selected').removeClass('selected')
        if $(@).hasClass('selectable')
          $(@).addClass('selected')
          $(@).trigger("selection:change")
        false

      @editor[0].onkeyup = () ->
        self.editor.find('.selected').removeClass('selected')
      @editor.click () ->
        self.editor.find('.selected').removeClass('selected')
        $(@).trigger("selection:change")

    scrollHandler: (event) ->
      if @needFixToolbar()
        @toolbar.css {
          position: 'fixed',
          top: $('header').height()
        }
      else
        @toolbar.css {
          position: 'static'
        }

    insertImage: (url) ->
      @editor.insertImage(url)
      $('.editor img').addClass 'selectable'
      #sel = window.getSelection()
      #return if sel.rangeCount < 1
      #range = sel.getRangeAt(0)
      #startNode = range.startContainer
      #if $(startNode).hasClass('editor')
        #@editor.insertHTML("<div><img src=#{url}></div>")
      #else
        #@editor.insertImage(url)
      return false

    needFixToolbar: () ->
      static_offset = $('header').height()
      elem = @editor
      docViewTop = static_offset + $(window).scrollTop()
      docViewBottom = static_offset + docViewTop + $(window).height()

      elemTop = @toolbar_placeholder.offset().top
      elemBottom = elemTop + elem.height()

      toolbar_too_high = (elemTop < docViewTop) && (elemBottom > docViewTop)
        
      #console.log elemTop+'<'+docViewTop+' and '+elemBottom+'>'+docViewTop

      return toolbar_too_high

    toggleClassOnSelection: (removeClasses, addClass) ->
      selected = @editor.find('.selected:first')
      if selected.length > 0
        wrapper = selected
        while (wrapper.parent() && !wrapper.parent().hasClass('editor'))
          wrapper = wrapper.parent()

        wrapper.after selected if wrapper!=selected

        $.each removeClasses, (i, name) ->
          selected.removeClass(name)

        selected.toggleClass(addClass)
        @editor.trigger("selection:change")
        return

    classSelected: (class_name) ->
      selected = @editor.find('.selected:first')
      if selected.length > 0
        return selected.hasClass class_name

      sel = window.getSelection()
      if (sel.rangeCount < 1)
          return

      range = sel.getRangeAt(0)

      node = $(sel.focusNode)
      return node.hasClass class_name

    tagSelected: (tag_name) ->
      sel = window.getSelection()
      if (sel.rangeCount < 1)
          return

      range = sel.getRangeAt(0)

      if sel.focusNode.nodeType == 3
        node = $(sel.focusNode).parent()
      else
        node = $(sel.focusNode)
      return node.prop('tagName') == tag_name

    content: () ->
      return @editor.html()

    setContent: (text) ->
      return @editor.html(text)

    save: () ->
      @textarea.value = @content()

    load: () ->
      @setContent(@textarea.value)

