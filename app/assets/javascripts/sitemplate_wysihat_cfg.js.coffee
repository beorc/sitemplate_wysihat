window.SITEMPLATE = {} unless window.SITEMPLATE
SITEMPLATE.lib = {} unless SITEMPLATE.lib
window.SITEMPLATE.lib.wysihat = {} unless window.SITEMPLATE.lib.wysihat

window.SITEMPLATE.lib.wysihat.cfg =
  buttons: {
    bold: {
      name: 'bold',
      label: '<i class="icon-bold"/>',
      init: (button) ->
        locale = window.SITEMPLATE.lib.wysihat.local.getLocale()
        button.
          attr('rel', 'tooltip').
          attr('data-original-title', window.SITEMPLATE.lib.wysihat.local.getLocale().toolbar.bold).
          tooltip().
          addClass('btn btn-small')
        group = $('<div/>').addClass('btn-group').insertBefore(button)
        button.appendTo group
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
          attr('data-original-title', window.SITEMPLATE.lib.wysihat.local.getLocale().toolbar.italic).
          tooltip().
          addClass('btn btn-small')
        group = button.prevAll('.btn-group:first')
        button.appendTo group
      handler: (editor) ->
        editor.italicSelection()
      query: (editor) ->
        editor.italicSelected()
    }
    underline: {
      name: 'underline',
      label: '<i class="icon-underlined"/>',
      init: (button) ->
        button.
          attr('rel', 'tooltip').
          attr('data-original-title', window.SITEMPLATE.lib.wysihat.local.getLocale().toolbar.underline).
          tooltip().
          addClass('btn btn-small')
        group = button.prevAll('.btn-group:first')
        button.appendTo group
      handler: (editor) ->
        editor.underlineSelection()
      query: (editor) ->
        editor.underlineSelected()
    }
    h1: {
      name: 'h1',
      label: '<i class="icon-h1"/>',
      init: (button) ->
        button.
          attr('rel', 'tooltip').
          attr('data-original-title', window.SITEMPLATE.lib.wysihat.local.getLocale().toolbar.h1).
          tooltip().
          addClass('btn btn-small')
        group = $('<div/>').addClass('btn-group').insertBefore(button)
        button.appendTo group
      handler: (editor) ->
        editor.formatblockSelection('H1')
      query: (editor) ->
        editor.handler.tagSelected('H1')
    }
    h2: {
      name: 'h2',
      label: '<i class="icon-h2"/>',
      init: (button) ->
        button.
          attr('rel', 'tooltip').
          attr('data-original-title', window.SITEMPLATE.lib.wysihat.local.getLocale().toolbar.h2).
          tooltip().
          addClass('btn btn-small')
        group = button.prevAll('.btn-group:first')
        button.appendTo group
      handler: (editor) ->
        editor.formatblockSelection('H2')
      query: (editor) ->
        editor.handler.tagSelected('H2')
    }
    h3: {
      name: 'h3',
      label: '<i class="icon-h3"/>',
      init: (button) ->
        button.
          attr('rel', 'tooltip').
          attr('data-original-title', window.SITEMPLATE.lib.wysihat.local.getLocale().toolbar.h3).
          tooltip().
          addClass('btn btn-small')
        group = button.prevAll('.btn-group:first')
        button.appendTo group
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
          attr('data-original-title', window.SITEMPLATE.lib.wysihat.local.getLocale().toolbar.align.left).
          tooltip().
          addClass('btn btn-small')
        group = $('<div/>').addClass('btn-group').insertBefore(button)
        button.appendTo group
      handler: (editor) ->
        editor.alignSelection 'left'
        editor.trigger("selection:change")
      query: (editor) ->
        'left' == editor.alignSelected()
    }
    block_center: {
      name: 'block_center',
      label: '<i class="icon-align-center"/>',
      init: (button) ->
        button.
          attr('rel', 'tooltip').
          attr('data-original-title', window.SITEMPLATE.lib.wysihat.local.getLocale().toolbar.align.center).
          tooltip().
          addClass('btn btn-small')
        group = button.prevAll('.btn-group:first')
        button.appendTo group
      handler: (editor) ->
        editor.alignSelection 'center'
        editor.trigger("selection:change")
      query: (editor) ->
        'center' == editor.alignSelected()
    }
    block_right: {
      name: 'block_right',
      label: '<i class="icon-align-right"/>',
      init: (button) ->
        button.
          attr('rel', 'tooltip').
          attr('data-original-title', window.SITEMPLATE.lib.wysihat.local.getLocale().toolbar.align.right).
          tooltip().
          addClass('btn btn-small')
        group = button.prevAll('.btn-group:first')
        button.appendTo group
      handler: (editor) ->
        editor.alignSelection 'right'
        editor.trigger("selection:change")
      query: (editor) ->
        'right' == editor.alignSelected()
    }
    block_justify: {
      name: 'block_justify',
      label: '<i class="icon-align-justify"/>',
      init: (button) ->
        button.
          attr('rel', 'tooltip').
          attr('data-original-title', window.SITEMPLATE.lib.wysihat.local.getLocale().toolbar.align.justify).
          tooltip().
          addClass('btn btn-small')
        group = button.prevAll('.btn-group:first')
        button.appendTo group
      handler: (editor) ->
        editor.alignSelection 'full'
      query: (editor) ->
        'justify' == editor.alignSelected()
    }
    ul: {
      name: 'ul',
      label: '<i class="icon-list"/>',
      init: (button) ->
        button.
          attr('rel', 'tooltip').
          attr('data-original-title', window.SITEMPLATE.lib.wysihat.local.getLocale().toolbar.ul).
          tooltip().
          addClass('btn btn-small')
        group = $('<div/>').addClass('btn-group').insertBefore(button)
        button.appendTo group
      handler: (editor) ->
        editor.toggleUnorderedList()
      query: (editor) ->
        editor.orderedListSelected()
    }
    ol: {
      name: 'ol',
      label: '<i class="icon-ol"/>',
      init: (button) ->
        button.
          attr('rel', 'tooltip').
          attr('data-original-title', window.SITEMPLATE.lib.wysihat.local.getLocale().toolbar.ol).
          tooltip().
          addClass('btn btn-small')
        group = button.prevAll('.btn-group:first')
        button.appendTo group
      handler: (editor) ->
        editor.toggleOrderedList()
      query: (editor) ->
        editor.unorderedListSelected()
    }
    image: {
      name: 'image',
      label: '<i class="icon-picture"/>',
      init: (button) ->
        button.
          attr('rel', 'tooltip').
          attr('data-original-title', window.SITEMPLATE.lib.wysihat.local.getLocale().toolbar.image).
          tooltip().
          addClass('btn btn-small')
        group = $('<div/>').addClass('btn-group').insertBefore(button)
        button.appendTo group
      handler: (editor) ->
        editor.handler.cfg.options.insertImageHandler(editor)
    }
    inline_left: {
      name: 'inline_left',
      label: '<i class="icon-pull-left"/>',
      init: (button) ->
        button.
          attr('rel', 'tooltip').
          attr('data-original-title', window.SITEMPLATE.lib.wysihat.local.getLocale().toolbar.inline.left).
          tooltip().
          addClass('btn btn-small')
        group = button.prevAll('.btn-group:first')
        button.appendTo group
      handler: (editor) ->
        classes = ['inline-left', 'inline-right']
        editor.handler.toggleClassOnSelection(classes, classes[0])
      query: (editor) ->
        editor.handler.classSelected('inline-left')
    }
    inline_right: {
      name: 'inline_right',
      label: '<i class="icon-pull-right"/>',
      init: (button) ->
        button.
          attr('rel', 'tooltip').
          attr('data-original-title', window.SITEMPLATE.lib.wysihat.local.getLocale().toolbar.inline.right).
          tooltip().
          addClass('btn btn-small')
        group = button.prevAll('.btn-group:first')
        button.appendTo group
      handler: (editor) ->
        classes = ['inline-left', 'inline-right']
        editor.handler.toggleClassOnSelection(classes, classes[1])
      query: (editor) ->
        editor.handler.classSelected('inline-right')
    }
    link: {
      name: 'link',
      label: '<i class="icon-link"/>',
      init: (button) ->
        button.
          attr('rel', 'tooltip').
          attr('data-original-title', window.SITEMPLATE.lib.wysihat.local.getLocale().toolbar.link).
          tooltip().
          addClass('btn btn-small')
        group = $('<div/>').addClass('btn-group').insertBefore(button)
        button.appendTo group
      handler: (editor) ->
        editor.handler.cfg.options.linkHandler(editor)
    }
    html: {
      name: 'html',
      label: '<i class="icon-html"/>',
      init: (button) ->
        button.
          attr('rel', 'tooltip').
          attr('data-original-title', window.SITEMPLATE.lib.wysihat.local.getLocale().toolbar.html).
          tooltip().
          addClass('btn btn-small')
        group = $('<div/>').addClass('btn-group').insertBefore(button)
        button.appendTo group
      handler: (editor) ->
        editor.handler.cfg.options.insertHTMLHandler(editor)
    }
    save: {
      name: 'save',
      label: '<i class="icon-ok icon-white"/>',
      init: (button) ->
        button.
          attr('rel', 'tooltip').
          attr('data-original-title', window.SITEMPLATE.lib.wysihat.local.getLocale().toolbar.save).
          tooltip().
          addClass('btn btn-success')
        group = $('<div/>').addClass('btn-group').insertBefore(button)
        button.appendTo group
      handler: (editor) ->
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

    insertHTMLHandler: (editor) ->
      value = prompt("Paste HTML", "")
      if value
        editor.insertHTML(value)

