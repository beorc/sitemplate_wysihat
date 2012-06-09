window.SITEMPLATE = {} unless window.SITEMPLATE
SITEMPLATE.lib = {} unless SITEMPLATE.lib

window.SITEMPLATE.lib.wysihat =
  cfg:
    buttons: {
      bold: {
        name: 'bold',
        label: 'Bold',
        handler: (editor) ->
          editor.boldSelection()
        query: (editor) ->
          editor.boldSelected()
      }
      italic: {
        name: 'italic',
        label: 'Italic',
        handler: (editor) ->
          editor.italicSelection()
        query: (editor) ->
          editor.italicSelected()
      }
      underline: {
        name: 'underline',
        label: 'Underline',
        handler: (editor) ->
          editor.underlineSelection()
        query: (editor) ->
          editor.underlineSelected()
      }
      ol: {
        name: 'ol',
        label: 'Ordered list',
        handler: (editor) ->
          editor.toggleOrderedList()
        query: (editor) ->
          editor.unorderedListSelected()
      }
      ul: {
        name: 'ul',
        label: 'Unordered list',
        handler: (editor) ->
          editor.toggleUnorderedList()
        query: (editor) ->
          editor.orderedListSelected()
      }
      link: {
        name: 'link',
        label: 'Link',
        handler: (editor) ->
          editor.handler.cfg.options.linkHandler(editor)
      }
      image: {
        name: 'image',
        label: 'Insert image',
        handler: (editor) ->
          editor.handler.cfg.options.insertImageHandler(editor)
      }
    }
    dropdowns: [
      {
        name: 'headers',
        label: 'Headers',
        options: [
            { label: "Headers", val: '' },
            { label: "H1", val: 'H1' },
            { label: 'H2', val: 'H2' },
            { label: 'H3', val: 'H3' }
        ],
        handler: (editor, val) ->
            editor.formatblockSelection(val)
      }
      {
        name: 'blocks',
        label: 'Blocks',
        options: [
            { label: "Blocks", val: '' },
            { label: "Block left", val: 0 }
            { label: "Block center", val: 1 }
            { label: "Block right", val: 2 }
        ]
        handler: (editor, val) ->
          classes = ['block-left', 'block-center', 'block-right']
          if val != ''
            editor.handler.toggleClassOnSelection(classes, classes[val])
          else
            editor.handler.toggleClassOnSelection(classes, '')
      }
      {
        name: 'inlines',
        label: 'Inlines',
        options: [
            { label: "Inlines", val: '' },
            { label: "Inline left", val: 0 }
            { label: "Inline right", val: 1 }
        ]
        handler: (editor, val) ->
          classes = ['inline-left', 'inline-right']
          if val != ''
            editor.handler.toggleClassOnSelection(classes, classes[val])
          else
            editor.handler.toggleClassOnSelection(classes, '')
      }
    ]
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

      @editor.addClass 'clearfix'

      toolbar = new WysiHat.Toolbar()
      toolbar.initialize(@editor)

      @toolbar = @editor.prevAll('.editor_toolbar:first')

      for name, button of cfg.buttons
        toolbar.addButton button if button

      for name, dropdown of cfg.dropdowns
        toolbar.addDropdown dropdown if dropdown

      @dynamic_toolbar = @toolbar.clone()
      @dynamic_toolbar.appendTo('body')
      @dynamic_toolbar.css {
          position: 'fixed',
          top: '10%',
          left: @toolbar.offset().left
          display: 'none'
      }

      @editor.parents('form:first').submit () =>
        @save()

      # Handlers

      $(window).bind "scroll", (event) =>
        @scrollHandler(event)

      @editor.on 'click', '*', () ->
        self.editor.find('.selected').removeClass('selected')
        $(@).addClass('selected') if $(@).hasClass('selectable')

      @editor[0].onkeyup = () ->
        self.editor.find('.selected').removeClass('selected')

    scrollHandler: (event) ->
      if @needFixToolbar()
        @dynamic_toolbar.css {
          display: 'block'
        }
      else
        @dynamic_toolbar.css {
          display: 'none'
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
      static_offset = @toolbar.height()
      elem = @editor
      docViewTop = static_offset + $(window).scrollTop()
      docViewBottom = static_offset + docViewTop + $(window).height()

      elemTop = elem.offset().top
      elemBottom = elemTop + elem.height()

      toolbar_too_high = (elemTop < docViewTop) && (elemBottom > docViewTop)
        
      #console.log elemTop+'<'+docViewTop+' and '+elemBottom+'>'+docViewTop

      return toolbar_too_high

    toggleClassOnSelection: (removeClasses, addClass) ->
      rangeIntersectsNode = (range, node) ->
        nodeRange = node.ownerDocument.createRange()
        try
          nodeRange.selectNode(node)
        catch e
          nodeRange.selectNodeContents(node)

        return range.compareBoundaryPoints(Range.END_TO_START, nodeRange) == -1 &&
               range.compareBoundaryPoints(Range.START_TO_END, nodeRange) == 1

      selected = @editor.find('.selected')
      if selected.length > 0
        $.each removeClasses, (i, name) ->
          selected.removeClass(name)

        selected.toggleClass(addClass)
        return

      sel = window.getSelection()
      if (sel.rangeCount < 1)
          return
      
      range = sel.getRangeAt(0)

      if (range.collapsed)
        node = sel.focusNode
        if !$(node).hasClass('editor')
          $.each removeClasses, (i, name) ->
            $(node).removeClass(name)

          if (node.nodeType != 1)
            $(node).wrap("<div class='#{addClass}'/>")
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

      for node in selectedNodes
        $.each removeClasses, (i, name) ->
          $(node).removeClass(name)

        wrapper = node
        while (wrapper.parentNode && wrapper.parentNode != range.commonAncestorContainer)
          wrapper = wrapper.parentNode

        if (wrapper.nodeType != 1)
          $(wrapper).wrap("<div class='#{addClass}'/>")
        else
          $(wrapper).toggleClass(addClass)

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

