window.SITEMPLATE = {} unless window.SITEMPLATE
SITEMPLATE.lib = {} unless SITEMPLATE.lib

window.SITEMPLATE.lib.wysihat =

  EditorHandler: class 
    constructor: (editor) ->
      self = @
      @textarea = editor
      @editor = WysiHat.Editor.attach($(editor))

      cfg = 
        buttons: [
          {
            name: 'bold',
            label: 'Bold',
            handler: (editor) ->
              editor.boldSelection()
            query: (editor) ->
              editor.boldSelected()
          }
          {
            name: 'italic',
            label: 'Italic',
            handler: (editor) ->
              editor.italicSelection()
            query: (editor) ->
              editor.italicSelected()
          }
          {
            name: 'underline',
            label: 'Underline',
            handler: (editor) ->
              editor.underlineSelection()
            query: (editor) ->
              editor.underlineSelected()
          }
          {
            name: 'ol',
            label: 'Ordered list',
            handler: (editor) ->
              editor.toggleOrderedList()
            query: (editor) ->
              editor.unorderedListSelected()
          }
          {
            name: 'ul',
            label: 'Unordered list',
            handler: (editor) ->
              editor.toggleUnorderedList()
            query: (editor) ->
              editor.orderedListSelected()
          }
          {
            name: 'image',
            label: 'Insert image',
            handler: (editor) ->
              self.insertImageHandler()
          }
        ]
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
              classes = ['pull-left', 'pull-center', 'pull-right']
              if val != ''
                self.toggleClassOnSelection(classes, classes[val])
              else
                self.toggleClassOnSelection(classes, '')
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
              classes = ['pull-left', 'pull-right']
              if val != ''
                self.toggleClassOnSelection(classes, classes[val])
              else
                self.toggleClassOnSelection(classes, '')
          }
        ]

      toolbar = new WysiHat.Toolbar()
      toolbar.initialize(@editor)

      @toolbar = @editor.prevAll('.editor_toolbar:first')

      $.each cfg.buttons, (i, button) ->
        toolbar.addButton button

      $.each cfg.dropdowns, (i, dropdown) ->
        toolbar.addDropdown dropdown

      @editor.closest('form:first').submit () =>
        @save()

      # Handlers

      $(window).bind "scroll", (event) =>
        @scrollHandler(event)

    scrollHandler: (event) ->
      if @needFixToolbar()
        @toolbar.css {
          position: 'fixed',
          top: '7%',
        }
      else
        @toolbar.css {
          position: 'static'
        }

    insertImageHandler: () ->
      sel = window.getSelection()
      return if sel.rangeCount < 1
      range = sel.getRangeAt(0)

      startNode = range.startContainer
      if $(startNode).hasClass('editor')
        @editor.insertHTML('<div><img src="http://www.whatever.com/myimage.gif"></div>')
      else
        @editor.insertImage("http://www.whatever.com/myimage.gif")
      return false

    needFixToolbar: () ->
      static_offset = 70
      elem = $(@editor)
      toolbar = $(@toolbar)
      toolbar_state = toolbar.css('position')
      docViewTop = static_offset + $(window).scrollTop()
      docViewBottom = static_offset + docViewTop + $(window).height()

      elemTop = $(elem).offset().top
      elemBottom = elemTop + $(elem).height()

      toolbar_too_high = false

      delta = 10
      if ('static' == toolbar_state)
        toolbar_too_high = (elemTop < (docViewTop + delta)) && (elemBottom > (docViewTop + delta))
      else
        toolbar_too_high = (elemTop < (docViewTop - delta)) && (elemBottom > (docViewTop - delta))
        
      #$('#debug').text(elemTop+'<'+docViewTop+' and '+elemBottom+'>'+docViewTop)

      return toolbar_too_high

    rangeIntersectsNode: (range, node) ->
      nodeRange = node.ownerDocument.createRange()
      try
        nodeRange.selectNode(node)
      catch e
        nodeRange.selectNodeContents(node)

      return range.compareBoundaryPoints(Range.END_TO_START, nodeRange) == -1 &&
             range.compareBoundaryPoints(Range.START_TO_END, nodeRange) == 1

    toggleClassOnSelection: (removeClasses, addClass) ->
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
           return if self.rangeIntersectsNode(range, node)
                    NodeFilter.FILTER_ACCEPT
                  else
                    NodeFilter.FILTER_REJECT
         ,
         false

      selectedNodes = []
      while (treeWalker.nextNode())
        selectedNodes.push(treeWalker.currentNode)

      #Place each text node within range inside a <span>
      #element with the desired class
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

  attach: () ->
    $(SITEMPLATE.lib.wysihat.EDITOR_SELECTOR).each (i, editor) ->
      handler = new SITEMPLATE.lib.wysihat.EditorHandler editor
      SITEMPLATE.lib.wysihat.instances.push(handler)

  init: () ->
    if ($(SITEMPLATE.lib.wysihat.EDITOR_SELECTOR).length > 0)
      $.getScript '/assets/jq-wysihat.js', SITEMPLATE.lib.wysihat.attach

