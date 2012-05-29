window.SITEMPLATE = {} unless window.SITEMPLATE
SITEMPLATE.lib = {} unless SITEMPLATE.lib

window.SITEMPLATE.lib.wysihat =

  EditorHandler: class 
    constructor: (editor) ->
      self = @
      @textarea = editor
      @editor = WysiHat.Editor.attach($(editor))

      cfg = 
        buttons: ['bold', 'italic', 'underline', 'image']
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
            query: (editor) ->
          }
          {
            name: 'classes',
            label: 'Classes',
            options: [
                { label: "Classes", val: '' },
                { label: "pull-right", val: 'pull-right' }
                ]
            handler: (editor, val) =>
              selection = window.getSelection()
              @applyClassToSelection(val)
            query: (editor) ->
          }
        ]

      toolbar = new WysiHat.Toolbar()
      toolbar.initialize(@editor)

      @toolbar = @editor.prevAll('.editor_toolbar:first')

      $.each cfg.buttons, (i, button) ->
        switch button.toLowerCase()
          when 'bold'
            toolbar.addButton {label : 'Strong', handler: (editor) -> return editor.boldSelection()}
          when 'italic'
            toolbar.addButton {label : 'Italic', handler: (editor) -> return editor.italicSelection()}
          when 'underline'
            toolbar.addButton {label : 'Underline', handler: (editor) -> return editor.underlineSelection()}
          when 'image'
            toolbar.addButton {label : 'Insert Image', handler: (editor) => return self.insertImageHandler()}
          else
            toolbar.addButton {label : button}

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

    toggleClassOnSelection: (cssClass) ->
      sel = window.getSelection()
      if (sel.rangeCount < 1)
          return
      
      range = sel.getRangeAt(0)

      startNode = range.startContainer
      endNode = range.endContainer

      if !$(startNode).hasClass(cssClass) || !$(endNode).hasClass(cssNode)
        applyClassToSelection(cssClass)

    applyClassToSelection: (cssClass) ->
      rangeIntersectsNode = (range, node) ->
        nodeRange = node.ownerDocument.createRange()
        try
          nodeRange.selectNode(node)
        catch e
          nodeRange.selectNodeContents(node)

        return range.compareBoundaryPoints(Range.END_TO_START, nodeRange) == -1 &&
               range.compareBoundaryPoints(Range.START_TO_END, nodeRange) == 1

      sel = window.getSelection()
      if (sel.rangeCount < 1)
          return
      
      range = sel.getRangeAt(0)

      if (range.collapsed)
         node = sel.focusNode
        if (!$(node).hasClass('editor'))
          if (node.nodeType != 1)
            $(node).wrap("<div class='#{cssClass}'/>")
          else
            $(node).addClass(cssClass)
        return

      startNode = range.startContainer
      endNode = range.endContainer

      #Split the start and end container text nodes, if necessary
      if (endNode.nodeType == 3)
        endNode.splitText(range.endOffset)
        range.setEnd(endNode, endNode.length)

      if (startNode.nodeType == 3)
        startNode = startNode.splitText(range.startOffset)
        range.setStart(startNode, 0)

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

      #Place each text node within range inside a <span>
      #element with the desired class
      for node in selectedNodes
        if (node.nodeType == 3)
          span = document.createElement("span")
          span.className = cssClass
          node.parentNode.insertBefore(span, node)
          span.appendChild(node)
        else
          wrapper = node
          while (wrapper.parentNode && wrapper.parentNode != range.commonAncestorContainer)
            wrapper = wrapper.parentNode

          $(wrapper).addClass(cssClass)

    removeClass: (cssClass) ->
      #spans = $(".#{cssClass}")

      ## Convert spans to an array to prevent live updating of
      ## the list as we remove the spans
      #spans = Array.prototype.slice.call(spans, 0);

      #for (var i = 0, len = spans.length; i < len; ++i)
        #span = spans[i];
        #parentNode = span.parentNode;
        #parentNode.insertBefore(span.firstChild, span);
        #parentNode.removeChild(span);

        ## Glue any adjacent text nodes back together
        #parentNode.normalize();

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

