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

      @undo_button = @toolbar.find '.button.undo'
      @redo_button = @toolbar.find '.button.redo'

      if @undo_button && @redo_button
        @undo = new window.SITEMPLATE.lib.wysihat.undo.Undo(@)
        @saveState()

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

      @editor.keyup () ->
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

    toggleClassOnSelectable: (removeClasses, addClass) ->
      selected = @editor.find('.selected:first')
      if selected.length > 0
        wrapper = selected
        while (wrapper.parent() && !wrapper.parent().hasClass('editor'))
          wrapper = wrapper.parent()

        wrapper.after selected if wrapper!=selected

        $.each removeClasses, (i, name) ->
          selected.removeClass(name)

        if addClass
          selected.toggleClass(addClass)
        @editor.trigger("selection:change")
        true
      false

    toggleClassOnSelection: (removeClasses, addClass) ->
      rangeIntersectsNode = (range, node) ->
        nodeRange = node.ownerDocument.createRange()
        try
          nodeRange.selectNode(node)
        catch e
          nodeRange.selectNodeContents(node)

        return range.compareBoundaryPoints(Range.END_TO_START, nodeRange) == -1 &&
               range.compareBoundaryPoints(Range.START_TO_END, nodeRange) == 1

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

          $.each removeClasses, (i, name) ->
            $(node).removeClass(name)

          if (node.nodeType != 1)
            target = $(node).wrap("<div class='#{addClass}'/>").parent()[0]
            rng = document.createRange()
            rng.selectNode target
            sel.removeAllRanges()
            sel.addRange rng
            sel.collapse target
          else
            $(node).toggleClass(addClass)
        return

      startNode = range.startContainer
      endNode = range.endContainer

      #Create an array of all the text nodes in the selection
      #using a TreeWalker
      containerElement = range.commonAncestorContainer
      if (containerElement.nodeType != 1)
        containerElement = containerElement.parentNode

      treeWalker = document.createTreeWalker containerElement,
         NodeFilter.SHOW_ALL,
         (node) ->
           return if rangeIntersectsNode(range, node)
                    NodeFilter.FILTER_ACCEPT
                  else
                    NodeFilter.FILTER_REJECT
         ,
         false

      selectedNodes = []
      while (treeWalker.nextNode())
        selectedNodes.push(treeWalker.currentNode)

      rng = document.createRange()
      for node in selectedNodes
        $.each removeClasses, (i, name) ->
          $(node).removeClass(name)

        #wrapper = node
        #while (wrapper.parentNode && wrapper.parentNode != containerElement)
          #wrapper = wrapper.parentNode

        #if (wrapper.nodeType != 1)
          #$(wrapper).wrap("<div class='#{addClass}'/>")
        #else
          #$(wrapper).toggleClass(addClass)
        if (node.nodeType == 3 && $(node).parent().hasClass('editor'))
          target = $(node).wrap("<div class='#{addClass}'/>").parent()[0]
          if rng.collapsed
            rng.selectNode target
          else
            rng.setEndAfter node

        if (node.nodeType != 3)
          $(node).toggleClass(addClass)
          if rng.collapsed
            rng.selectNode node
          else
            rng.setEndAfter node

      sel.removeAllRanges()
      sel.addRange rng

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

