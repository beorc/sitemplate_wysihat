$(document).ready(function() {
  EDITOR_SELECTOR = '.sitemplate-rich-editor'

  function needFixToolbar()
  {
      var elem = $(EDITOR_SELECTOR)
      var toolbar = $('.editor_toolbar')
      var toolbar_state = toolbar.css('position')
      var docViewTop = $(window).scrollTop();
      var docViewBottom = docViewTop + $(window).height();

      var elemTop = $(elem).offset().top;
      var elemBottom = elemTop + $(elem).height();

      var toolbar_too_high = false

      var delta = 10
      if ('static' == toolbar_state)
        toolbar_too_high = (elemTop < (docViewTop + delta)) && (elemBottom > docViewTop + delta);
      else
        toolbar_too_high = (elemTop < (docViewTop - delta)) && (elemBottom > docViewTop - delta);

      return toolbar_too_high
  }

  function rangeIntersectsNode(range, node) {
    var nodeRange = node.ownerDocument.createRange();
    try {
      nodeRange.selectNode(node);
    }
    catch (e) {
      nodeRange.selectNodeContents(node);
    }

    return range.compareBoundaryPoints(Range.END_TO_START, nodeRange) == -1 &&
           range.compareBoundaryPoints(Range.START_TO_END, nodeRange) == 1;
  }

  function applyClassToSelection(cssClass) {
    var sel = window.getSelection();
    if (sel.rangeCount < 1) {
        return;
    }
    var range = sel.getRangeAt(0);

    if (range.collapsed) {
      var node = sel.focusNode;
      if (!$(node).hasClass('editor')) {
        if (node.nodeType != 1)
          $(node).wrap('<div class="'+ cssClass +'"/>');
        else
          $(node).addClass(cssClass);
      }
      return;
    }

    var startNode = range.startContainer, endNode = range.endContainer;

    // Split the start and end container text nodes, if necessary
    if (endNode.nodeType == 3) {
      endNode.splitText(range.endOffset);
      range.setEnd(endNode, endNode.length);
    }

    if (startNode.nodeType == 3) {
      startNode = startNode.splitText(range.startOffset);
      range.setStart(startNode, 0);
    }

    // Create an array of all the text nodes in the selection
    // using a TreeWalker
    var containerElement = range.commonAncestorContainer;
    if (containerElement.nodeType != 1) {
      containerElement = containerElement.parentNode;
    }

    var treeWalker = document.createTreeWalker(
      containerElement,
      NodeFilter.SHOW_ALL,
      // Note that Range.intersectsNode is non-standard but
      // implemented in WebKit
      function(node) {
        return rangeIntersectsNode(range, node) ?
            NodeFilter.FILTER_ACCEPT : NodeFilter.FILTER_REJECT;
      },
      false
    );

    var selectedNodes = [];
    while (treeWalker.nextNode()) {
      selectedNodes.push(treeWalker.currentNode);
    }

    var node, span;

    // Place each text node within range inside a <span>
    // element with the desired class
    for (var i = 0, len = selectedNodes.length; i < len; ++i) {
      node = selectedNodes[i];
      if (node.nodeType == 3) {
        span = document.createElement("span");
        span.className = cssClass;
        node.parentNode.insertBefore(span, node);
        span.appendChild(node);
      } else {
        var wrapper = node;
        while (wrapper.parentNode &&
               wrapper.parentNode != range.commonAncestorContainer) {
          wrapper = wrapper.parentNode;
        }

        $(wrapper).addClass(cssClass);
      }
    }
  }

  function removeSpansWithClass(cssClass) {
    var spans = document.body.getElementsByClassName(cssClass),
        span, parentNode;

    // Convert spans to an array to prevent live updating of
    // the list as we remove the spans
    spans = Array.prototype.slice.call(spans, 0);

    for (var i = 0, len = spans.length; i < len; ++i) {
      span = spans[i];
      parentNode = span.parentNode;
      parentNode.insertBefore(span.firstChild, span);
      parentNode.removeChild(span);

      // Glue any adjacent text nodes back together
      parentNode.normalize();
    }
  }

  var editor = WysiHat.Editor.attach($("#content"));
  offset = editor.offset();

  var boldButton = $('.editor_toolbar .bold').first();
  boldButton.click(function(event) {
    editor.boldSelection();
    return false;
  });
  editor.bind('wysihat:cursormove', function(event) {
    if (editor.boldSelected())
      boldButton.addClass('selected')
    else
      boldButton.removeClass('selected');
  });

  $(window).bind("scroll", function(event) {
    if (needFixToolbar()) {
      $('.editor_toolbar').css({
        position: 'fixed',
        top: '2%',
      });
    } else
    {
      $('.editor_toolbar').css({
        position: 'static'
      });
    }
  });

  var underlineButton = $('.editor_toolbar .underline').first();
  underlineButton.click(function(event) {
    editor.underlineSelection();
    
    return false;
  });
  editor.bind('wysihat:cursormove', function(event) {
    if (editor.underlineSelected())
      underlineButton.addClassName('selected')
    else
      underlineButton.removeClassName('selected');
  });

  var italicButton = $('.editor_toolbar .italic').first();
  italicButton.click(function(event) {
    editor.italicSelection();
    return false;
  });
  editor.bind('wysihat:cursormove', function(event) {
    if (editor.italicSelected())
      italicButton.addClassName('selected')
    else
      italicButton.removeClassName('selected');
  });

  var imageButton = $('.editor_toolbar .image').first();
  imageButton.click(function(event) {
    var sel = window.getSelection();
    if (sel.rangeCount < 1) {
        return;
    }
    var range = sel.getRangeAt(0);

    var startNode = range.startContainer;
    if ($(startNode).hasClass('editor'))
      editor.insertHTML('<div><img src="http://www.whatever.com/myimage.gif"></div>');
    else
      editor.insertImage("http://www.whatever.com/myimage.gif");
    return false;
  });

  var pullRightButton = $('.editor_toolbar .right').first();
  pullRightButton.click(function(event) {
    var selection = window.getSelection();
    var class_name = 'pull-right';

    applyClassToSelection(class_name);
    
    return false;
  });

  // Hide our error message if the editor loads fine
  $('#error').hide();
});
