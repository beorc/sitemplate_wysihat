window.SITEMPLATE = {} unless window.SITEMPLATE
SITEMPLATE.lib = {} unless SITEMPLATE.lib

window.SITEMPLATE.lib.wysihat =
  EditorHandler: class 
    constructor: (editor) ->
      self = @
      @editor = WysiHat.Editor.attach($(editor))

      cfg = 
        buttons: ['bold', 'italic', 'underline']

      toolbar = new WysiHat.Toolbar()
      toolbar.initialize(@editor)

      @toolbar = @editor.prevAll('.editor_toolbar')

      $.each cfg.buttons, (i, button) ->
        toolbar.addButton {label : button}
        #switch button.toLowerCase()
          #when 'bold'
            #toolbar.addButton {label : button, handler: (editor) -> return editor.boldSelection()}
          #else
            #toolbar.addButton {label : button}

      $(@editor).closest('form').submit () ->
        $(@editor).save()

      # Handlers

      $(window).bind "scroll", (event) -> 
        self.scrollHandler(event)

      boldButton = $('.editor_toolbar .bold').first()
      boldButton.click (event) ->
        @editor.boldSelection()
        return false

      @editor.bind 'wysihat:cursormove', (event) ->
        if (@editor.boldSelected())
          boldButton.addClass('selected')
        else
          boldButton.removeClass('selected')

      underlineButton = $('.editor_toolbar .underline').first()
      underlineButton.click (event) ->
        @editor.underlineSelection()
        return false

      @editor.bind 'wysihat:cursormove', (event) ->
        if @editor.underlineSelected()
          underlineButton.addClassName('selected')
        else
          underlineButton.removeClassName('selected')

      italicButton = $('.editor_toolbar .italic').first()
      italicButton.click (event) ->
        @editor.italicSelection()
        return false

      @editor.bind 'wysihat:cursormove', (event) ->
        if @editor.italicSelected()
          italicButton.addClassName('selected')
        else
          italicButton.removeClassName('selected')

      imageButton = $('.editor_toolbar .image').first()
      imageButton.click (event) ->
        sel = window.getSelection()
        return if sel.rangeCount < 1
        range = sel.getRangeAt(0)

        startNode = range.startContainer
        if $(startNode).hasClass('editor')
          @editor.insertHTML('<div><img src="http:www.whatever.com/myimage.gif"></div>')
        else
          @editor.insertImage("http:www.whatever.com/myimage.gif")
        return false

      pullRightButton = $('.editor_toolbar .right').first()
      pullRightButton.click (event) ->
        selection = window.getSelection()
        class_name = 'pull-right'

        applyClassToSelection(class_name)
        
        return false

            
    scrollHandler: (event) ->
      if @needFixToolbar()
        @toolbar.css {
          position: 'fixed',
          top: '10%',
        }
      else
        @toolbar.css {
          position: 'static'
        }

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
      #toolbar_too_high = (elemTop < docViewTop) && (elemBottom > docViewTop)
      if ('static' == toolbar_state)
        toolbar_too_high = (elemTop < (docViewTop + delta)) && (elemBottom > (docViewTop + delta))
      else
        toolbar_too_high = (elemTop < (docViewTop - delta)) && (elemBottom > (docViewTop - delta))
        
      #$('#debug').text(elemTop+'<'+docViewTop+' and '+elemBottom+'>'+docViewTop)

      return toolbar_too_high

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
            $(node).wrap('<div class="'+ cssClass +'"/>')
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

  EDITOR_SELECTOR: '.sitemplate-rich-editor'

  instances: []

  attach: () ->
    $(SITEMPLATE.lib.wysihat.EDITOR_SELECTOR).each (i, editor) ->
      handler = new SITEMPLATE.lib.wysihat.EditorHandler editor
      SITEMPLATE.lib.wysihat.instances.push(handler)

  init: () ->
    if ($(SITEMPLATE.lib.wysihat.EDITOR_SELECTOR).length > 0)
      $.getScript '/assets/jq-wysihat.js', SITEMPLATE.lib.wysihat.attach
