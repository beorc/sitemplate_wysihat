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
      if @editor.html().length == 0
        self.setContent('<br>')

      @editor.addClass 'clearfix'

      for style in cfg.styles
        @editor.addClass style

      # set up toolbar
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
        addClass('placeholder')

      if @toolbar.outerHeight() > 0
        height = @toolbar.outerHeight()
      else
        height = cfg.HEADER_HEIGHT

      @toolbar_placeholder.css {
        height: height
      }

      @editor.before @toolbar_placeholder
      @toolbar.appendTo @toolbar_placeholder

      @undo_button = @toolbar.find '.button.undo'
      @redo_button = @toolbar.find '.button.redo'

      if @undo_button && @redo_button
        @undo = new window.SITEMPLATE.lib.wysihat.undo.Undo(@)
        @saveState()

      form = @editor.parents('form:first')
      form.submit () =>
        @save()

      form.bind "show", () ->
        self.load()
        self.scrollHandler()

      # Handlers

      $(window).bind "scroll", (event) =>
        @scrollHandler()

      @editor.on 'click', '*', () ->
        self.editor.find('.selected').removeClass('selected')
        if $(@).hasClass('selectable')
          $(@).addClass('selected')
          $(@).trigger("selection:change")
        false

      @editor.keyup () ->
        self.editor.find('.selected').removeClass('selected')

      @editor.click () ->
        self.editor.find('.selected').removeClass('selected')
        $(@).trigger("selection:change")

      @editor.bind 'paste', (e) ->
        self.editor.find('*').each () ->
          $(@).addClass('__before_paste__')
        callback = () -> self.afterPaste(self.editor)
        self.pastetimer = window.setTimeout( callback, 10);

      if self.framed()
        @editor.focus () ->
          self.editor.addClass 'wysihat-selected'

      if self.framed()
        @editor.blur () ->
          self.editor.removeClass 'wysihat-selected'

    scrollHandler: () ->
      if @needFixToolbar()
        @toolbar.css {
          position: 'fixed',
          top: $(@cfg.HEADER_SELECTOR).height()
        }
      else
        @toolbar.css {
          position: 'static'
        }

    insertImage: (url) ->
      @editor.focus()
      @editor.insertImage(url)
      @adaptContent()
      return false

    needFixToolbar: () ->
      if @cfg.HEADER_SELECTOR
        static_offset = $(@cfg.HEADER_SELECTOR).height()
      else
        static_offset = @cfg.TOP_OFFSET

      elem = @editor
      docViewTop = static_offset + $(window).scrollTop()
      docViewBottom = static_offset + docViewTop + $(window).height()

      elemTop = @toolbar_placeholder.offset().top
      elemBottom = elemTop + elem.height()

      toolbar_too_high = (elemTop < docViewTop) && (elemBottom > docViewTop)
        
      #console.log elemTop+'<'+docViewTop+' and '+elemBottom+'>'+docViewTop

      return toolbar_too_high

    toggleClass: (selected, removeClasses, addClass) ->
      wrapper = selected
      while (wrapper.parent() && !wrapper.parent().hasClass('editor'))
        wrapper = wrapper.parent()

      wrapper.after selected if wrapper!=selected

      $.each removeClasses, (i, name) ->
        selected.removeClass(name)

      if addClass
        selected.toggleClass(addClass)
      @editor.trigger("selection:change")

    toggleClassOnSelectable: (removeClasses, addClass) ->
      selected = @editor.find('.selected:first')
      if selected.length > 0
        @toggleClass selected, removeClasses, addClass
        true
      false

    toggleClassOnSelection: (removeClasses, addClass) ->
      self = @
      return if @toggleClassOnSelectable(removeClasses, addClass)

      sel = window.getSelection()
      if (sel.rangeCount < 1)
          return
      
      range = sel.getRangeAt(0)

      if (range.collapsed)
        node = sel.focusNode
        if !$(node).hasClass('editor')
          if (node.nodeType == 3 && !$(node).parent().hasClass('editor'))
            node = node.parentNode

          if (node.nodeType != 1)
            target = $(node).wrap("<div class='#{addClass}'/>").parent()[0]
            new_range = document.createRange()
            new_range.selectNode target
            sel.removeAllRanges()
            sel.addRange new_range
            sel.collapse target
          else
            $.each removeClasses, (i, name) ->
              $(node).removeClass(name)

            $(node).toggleClass(addClass)
        return

      editing_class = '__stwh_editing__'
      newRange = document.createRange()

      handleElement = (element) ->
        unless element.hasClass(editing_class)
          element.addClass(editing_class)
          element.toggleClass(addClass)

          if newRange.collapsed
            newRange.selectNode element[0]
          else
            newRange.setEndAfter element[0]

      @editor.contents().each () ->
        if self.rangeIntersectsNode(range, @)
          node = @
          $.each removeClasses, (i, name) ->
            $(node).removeClass(name)

          if (node.nodeType == 3)
            if $(node).parent().hasClass('editor')
              target = $(node).wrap("<div/>").parent()
              handleElement(target)
            else
              wrapper = $(node).parent()
              handleElement(wrapper)
          else
            handleElement($(node))
      
      @editor.find('*').removeClass(editing_class)
      sel.removeAllRanges()
      sel.addRange newRange

    classSelected: (class_name) ->
      selected = @editor.find('.selected:first')
      if selected.length > 0
        return selected.hasClass class_name

      sel = window.getSelection()
      if (sel.rangeCount < 1)
          return

      range = sel.getRangeAt(0)

      if (sel.focusNode.nodeType != 1)
        node = $(sel.focusNode).parent()
      else
        node = $(sel.focusNode)
      return node.hasClass class_name

    tagSelected: (tag) ->
      self = this
      result = false

      sel = window.getSelection()
      if (sel.rangeCount < 1)
          return

      range = sel.getRangeAt(0)

      if (range.collapsed)
        node = sel.focusNode
        return false if $(node).hasClass('editor')
        while (node.tagName != tag && !$(node).parent().hasClass('editor'))
          node = node.parentNode
        return node.tagName == tag

      @editor.find('*').each () ->
        if self.rangeIntersectsNode(range, @)
          node = @
          while (node.tagName != tag && !$(node).parent().hasClass('editor'))
            node = node.parentNode

          if node.tagName == tag
            result = true
          else
            result = $(node).find(tag).length > 0

      result

    removeTagFromSelection: (tag) ->

      sel = window.getSelection()
      if (sel.rangeCount < 1)
          return true
      
      self = @
      new_range = document.createRange()
      range = sel.getRangeAt(0)

      handleNode = (node) ->
        extract = (node) ->
          if node.tagName == tag
            contents = $(node).contents()
            $(node).after contents
            $(node).remove()
            contents.each () ->
              if new_range.collapsed
                new_range.selectNode @
              else
                new_range.setEndAfter @

        source_node = node

        while (node.tagName != tag && !$(node).parent().hasClass('editor'))
          node = node.parentNode
        extract node

        unless range.collapsed
          node = source_node
          $(node).find(tag).each () ->
            extract @
        true

      if (range.collapsed)
        node = sel.focusNode
        handleNode node
        sel.removeAllRanges()
        sel.addRange new_range
        sel.collapse new_range.startContainer

        return

      @editor.contents().each () ->
        if self.rangeIntersectsNode(range, @)
          handleNode @

      sel.removeAllRanges()
      sel.addRange new_range
      true

    rangeIntersectsNode: (range, node) ->
      nodeRange = node.ownerDocument.createRange()
      try
        nodeRange.selectNode(node)
      catch e
        nodeRange.selectNodeContents(node)

      return range.compareBoundaryPoints(Range.END_TO_START, nodeRange) == -1 &&
             range.compareBoundaryPoints(Range.START_TO_END, nodeRange) == 1

    framed: () ->
      return 'wysihat-framed' in @cfg.styles

    content: () ->
      return @editor.html()

    setContent: (text) ->
      return @editor.html(text)

    save: () ->
      @textarea.value = @content()
      $('.editor_toolbar .button').tooltip('hide')

    load: () ->
      @setContent(@textarea.value)

    saveState: () ->
      if @undo
        @undo.push()
        @updateButtons()

    rollback: () ->
      if @undo
        @undo.undo()
        @updateButtons()
        @editor.trigger("selection:change")

    redo: () ->
      if @undo
        @undo.redo()
        @updateButtons()
        @editor.trigger("selection:change")

    updateButtons: () ->
      if @undo
        if @undo.hasUndo()
          @undo_button.removeClass 'disabled'
        else
          @undo_button.addClass 'disabled'

        if @undo.hasRedo()
          @redo_button.removeClass 'disabled'
        else
          @redo_button.addClass 'disabled'

    adaptContent: () ->
      $('.editor img').addClass 'selectable'

    afterPaste: (editor) ->
      editor.find('*').each () ->
        if $(@).hasClass '__before_paste__'
          $(@).removeClass '__before_paste__'
        else
          $(@).removeAttr('class')
          $(@).removeAttr('style')

      editor.handler.adaptContent()

