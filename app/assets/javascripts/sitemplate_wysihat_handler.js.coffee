window.SITEMPLATE = {} unless window.SITEMPLATE
SITEMPLATE.lib = {} unless SITEMPLATE.lib

window.SITEMPLATE.lib.wysihat =
  cfg:
    buttons: {
      bold: {
        name: 'bold',
        label: '<i class="icon-bold"/>',
        init: (button) ->
          button.
            attr('rel', 'tooltip').
            attr('data-original-title', 'Bold')
            button.tooltip()
        handler: (editor) ->
          editor.boldSelection()
        query: (editor) ->
          editor.boldSelected()
      }
      italic: {
        name: 'italic',
        label: '<i class="icon-italic"/>',
        init: (button) ->
          button.
            attr('rel', 'tooltip').
            attr('data-original-title', 'Italic')
            button.tooltip()
        handler: (editor) ->
          editor.italicSelection()
        query: (editor) ->
          editor.italicSelected()
      }
      underline: {
        name: 'underline',
        label: '<i class="icon-pencil"/>',
        init: (button) ->
          button.
            attr('rel', 'tooltip').
            attr('data-original-title', 'Underline')
            button.tooltip()
        handler: (editor) ->
          editor.underlineSelection()
        query: (editor) ->
          editor.underlineSelected()
      }
      ol: {
        name: 'ol',
        label: '<i class="icon-th-list"/>',
        init: (button) ->
          button.
            attr('rel', 'tooltip').
            attr('data-original-title', 'Ordered list')
            button.tooltip()
        handler: (editor) ->
          editor.toggleOrderedList()
        query: (editor) ->
          editor.unorderedListSelected()
      }
      ul: {
        name: 'ul',
        label: '<i class="icon-list"/>',
        init: (button) ->
          button.
            attr('rel', 'tooltip').
            attr('data-original-title', 'Unordered list')
            button.tooltip()
        handler: (editor) ->
          editor.toggleUnorderedList()
        query: (editor) ->
          editor.orderedListSelected()
      }
      link: {
        name: 'link',
        label: '<i class="icon-globe"/>',
        init: (button) ->
          button.
            attr('rel', 'tooltip').
            attr('data-original-title', 'Link')
            button.tooltip()
        handler: (editor) ->
          editor.handler.cfg.options.linkHandler(editor)
      }
      image: {
        name: 'image',
        label: '<i class="icon-picture"/>',
        init: (button) ->
          button.
            attr('rel', 'tooltip').
            attr('data-original-title', 'Image')
            button.tooltip()
            button.after('<span class="divider-vertical"/>')
        handler: (editor) ->
          editor.handler.cfg.options.insertImageHandler(editor)
      }
      h1: {
        name: 'h1',
        label: '<i class="icon-certificate"/>',
        init: (button) ->
          button.
            attr('rel', 'tooltip').
            attr('data-original-title', 'Header 1')
            button.tooltip()
        handler: (editor) ->
          editor.formatblockSelection('H1')
        query: (editor) ->
          editor.handler.tagSelected('H1')
      }
      h2: {
        name: 'h2',
        label: '<i class="icon-certificate"/>',
        init: (button) ->
          button.
            attr('rel', 'tooltip').
            attr('data-original-title', 'Header 2')
            button.tooltip()
        handler: (editor) ->
          editor.formatblockSelection('H2')
        query: (editor) ->
          editor.handler.tagSelected('H2')
      }
      h3: {
        name: 'h3',
        label: '<i class="icon-certificate"/>',
        init: (button) ->
          button.
            attr('rel', 'tooltip').
            attr('data-original-title', 'Header 3')
            button.tooltip()
            button.after('<span class="divider-vertical"/>')
        handler: (editor) ->
          editor.formatblockSelection('H3')
        query: (editor) ->
          editor.handler.tagSelected('H3')
      }
      block_left: {
        name: 'block_left',
        label: '<i class="icon-align-left"/>',
        init: (button) ->
          button.
            attr('rel', 'tooltip').
            attr('data-original-title', 'Left block')
            button.tooltip()
        handler: (editor) ->
          classes = ['block-left', 'block-center', 'block-right']
          editor.handler.toggleClassOnSelection(classes, classes[0])
        query: (editor) ->
          editor.handler.classSelected('block-left')
      }
      block_center: {
        name: 'block_center',
        label: '<i class="icon-align-center"/>',
        init: (button) ->
          button.
            attr('rel', 'tooltip').
            attr('data-original-title', 'Center block')
            button.tooltip()
        handler: (editor) ->
          classes = ['block-left', 'block-center', 'block-right']
          editor.handler.toggleClassOnSelection(classes, classes[1])
        query: (editor) ->
          editor.handler.classSelected('block-center')
      }
      block_right: {
        name: 'block_right',
        label: '<i class="icon-align-right"/>',
        init: (button) ->
          button.
            attr('rel', 'tooltip').
            attr('data-original-title', 'Right block')
            button.tooltip()
            button.after('<span class="divider-vertical"/>')
        handler: (editor) ->
          classes = ['block-left', 'block-center', 'block-right']
          editor.handler.toggleClassOnSelection(classes, classes[2])
        query: (editor) ->
          editor.handler.classSelected('block-right')
      }
      inline_left: {
        name: 'inline_left',
        label: '<i class="icon-align-left"/>',
        init: (button) ->
          button.
            attr('rel', 'tooltip').
            attr('data-original-title', 'Left inline')
            button.tooltip()
        handler: (editor) ->
          classes = ['inline-left', 'inline-right']
          editor.handler.toggleClassOnSelection(classes, classes[0])
        query: (editor) ->
          editor.handler.classSelected('inline-left')
      }
      inline_right: {
        name: 'inline_right',
        label: '<i class="icon-align-right"/>',
        init: (button) ->
          button.
            attr('rel', 'tooltip').
            attr('data-original-title', 'Right inline')
            button.tooltip()
        handler: (editor) ->
          classes = ['inline-left', 'inline-right']
          editor.handler.toggleClassOnSelection(classes, classes[1])
        query: (editor) ->
          editor.handler.classSelected('inline-right')
      }
    }
    options:
      insertImageHandler: (editor) ->
        value = prompt("Enter image URL", "http://www.whatever.com/myimage.gif")
        if value
          editor.handler.insertImage(value)

      linkHandler: (editor) ->
        if editor.linkSelected()
          if confirm("Remove link?")
            editor.unlinkSelection()
        else
          value = prompt("Enter a URL", "")
          if value
            editor.linkSelection(value)

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


  EDITOR_SELECTOR: '.sitemplate-rich-editor'

  instances: []

  attach: (editors, cfg) ->
    editors.each (i, editor) ->
      handler = new SITEMPLATE.lib.wysihat.EditorHandler(editor, cfg)
      SITEMPLATE.lib.wysihat.instances.push(handler)

  attachAll: (cfg) ->
    SITEMPLATE.lib.wysihat.attach($(SITEMPLATE.lib.wysihat.EDITOR_SELECTOR), cfg)

  initAll: (cfg) ->
    if ($(SITEMPLATE.lib.wysihat.EDITOR_SELECTOR).length > 0)
      $.getScript '/assets/jq-wysihat.js', () ->
        cfg = SITEMPLATE.lib.wysihat.cfg unless cfg
        SITEMPLATE.lib.wysihat.attachAll(cfg)

  init: (editors, cfg) ->
    if (editors.length > 0)
      $.getScript '/assets/jq-wysihat.js', () ->
        cfg = SITEMPLATE.lib.wysihat.cfg unless cfg
        SITEMPLATE.lib.wysihat.attach(editors, cfg)

