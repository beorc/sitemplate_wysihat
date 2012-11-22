window.SITEMPLATE = {} unless window.SITEMPLATE
SITEMPLATE.lib = {} unless SITEMPLATE.lib
window.SITEMPLATE.lib.wysihat = {} unless window.SITEMPLATE.lib.wysihat

window.SITEMPLATE.lib.wysihat.helpers =
  toggle_class:
    handler: (editor, classes, index) ->
        editor.handler.saveState()

        if editor.handler.classSelected(classes[index])
          editor.handler.toggleClassOnSelection(classes)
        else
          editor.handler.toggleClassOnSelection(classes, classes[index])
        editor.trigger("selection:change")
    query: (editor, classes, index) ->
      editor.handler.classSelected(classes[index])

  toggle_tag:
    handler: (editor, tag) ->
      editor.handler.saveState()

      if editor.handler.tagSelected(tag)
        editor.handler.removeTagFromSelection(tag)
      else
        editor.formatblockSelection(tag)
    query: (editor, tag) ->
      editor.handler.tagSelected(tag)

window.SITEMPLATE.lib.wysihat.cfg =

  BLOCK_ALIGN_CLASSES: ['block-left', 'block-center', 'block-right', 'block-justify']
  IMAGE_ALIGN_CLASSES: ['image-left', 'image-center', 'image-right']
  INLINE_CLASSES: ['inline-left', 'inline-right']
  TOOLTIP_OPTIONS: placement: 'bottom'
  HEADER_SELECTOR: '#top-panel'
  HEADER_HEIGHT: 33
  TOP_OFFSET: 7
  USE_SANITIZER: true
  styles: ['wysihat-framed', 'wysihat-scrollable']
  sanitize: {
    basic: {
      elements: [
       'a', 'b', 'blockquote', 'br', 'cite', 'code', 'dd', 'dl', 'dt', 'em',
       'i', 'li', 'ol', 'p', 'pre', 'q', 'small', 'strike', 'strong', 'sub',
       'sup', 'u', 'ul', 'div'],

      attributes: {
       'a'         : ['href'],
       'blockquote': ['cite'],
       'q'         : ['cite']
      },

      add_attributes: {
       'a': {'rel': 'nofollow'}
      },

      protocols: {
       'a'         : {'href': ['ftp', 'http', 'https', 'mailto',
                                   Sanitize.RELATIVE]},
       'blockquote': {'cite': ['http', 'https', Sanitize.RELATIVE]},
       'q'         : {'cite': ['http', 'https', Sanitize.RELATIVE]}
      }
    }
  }

  buttons: {
    undo: {
      name: 'undo',
      label: '<i class="undo icon-undo"/>',
      init: (button) ->
        locale = window.SITEMPLATE.lib.wysihat.local.getLocale()
        button.
          attr('rel', 'tooltip').
          attr('data-original-title', window.SITEMPLATE.lib.wysihat.local.getLocale().toolbar.undo).
          tooltip(window.SITEMPLATE.lib.wysihat.cfg.TOOLTIP_OPTIONS).
          addClass('btn btn-small disabled')
        group = $('<div/>').addClass('btn-group').insertBefore(button)
        button.appendTo group
      handler: (editor) ->
        editor.handler.rollback()
    }
    redo: {
      name: 'redo',
      label: '<i class="redo icon-redo"/>',
      init: (button) ->
        button.
          attr('rel', 'tooltip').
          attr('data-original-title', window.SITEMPLATE.lib.wysihat.local.getLocale().toolbar.redo).
          tooltip(window.SITEMPLATE.lib.wysihat.cfg.TOOLTIP_OPTIONS).
          addClass('btn btn-small disabled')
        group = button.prevAll('.btn-group:first')
        button.appendTo group
      handler: (editor) ->
        editor.handler.redo()
    }
    bold: {
      name: 'bold',
      label: '<i class="icon-bold"/>',
      init: (button) ->
        locale = window.SITEMPLATE.lib.wysihat.local.getLocale()
        button.
          attr('rel', 'tooltip').
          attr('data-original-title', window.SITEMPLATE.lib.wysihat.local.getLocale().toolbar.bold).
          tooltip(window.SITEMPLATE.lib.wysihat.cfg.TOOLTIP_OPTIONS).
          addClass('btn btn-small')
        group = $('<div/>').addClass('btn-group').insertBefore(button)
        button.appendTo group
      handler: (editor) ->
        editor.handler.saveState()
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
          tooltip(window.SITEMPLATE.lib.wysihat.cfg.TOOLTIP_OPTIONS).
          addClass('btn btn-small')
        group = button.prevAll('.btn-group:first')
        button.appendTo group
      handler: (editor) ->
        editor.handler.saveState()
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
          tooltip(window.SITEMPLATE.lib.wysihat.cfg.TOOLTIP_OPTIONS).
          addClass('btn btn-small')
        group = button.prevAll('.btn-group:first')
        button.appendTo group
      handler: (editor) ->
        editor.handler.saveState()
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
          tooltip(window.SITEMPLATE.lib.wysihat.cfg.TOOLTIP_OPTIONS).
          addClass('btn btn-small')
        group = $('<div/>').addClass('btn-group').insertBefore(button)
        button.appendTo group
      handler: (editor) ->
        window.SITEMPLATE.lib.wysihat.helpers.toggle_tag.handler(editor, 'H1')
      query: (editor) ->
        window.SITEMPLATE.lib.wysihat.helpers.toggle_tag.query(editor, 'H1')
    }
    h2: {
      name: 'h2',
      label: '<i class="icon-h2"/>',
      init: (button) ->
        button.
          attr('rel', 'tooltip').
          attr('data-original-title', window.SITEMPLATE.lib.wysihat.local.getLocale().toolbar.h2).
          tooltip(window.SITEMPLATE.lib.wysihat.cfg.TOOLTIP_OPTIONS).
          addClass('btn btn-small')
        group = button.prevAll('.btn-group:first')
        button.appendTo group
      handler: (editor) ->
        window.SITEMPLATE.lib.wysihat.helpers.toggle_tag.handler(editor, 'H2')
      query: (editor) ->
        window.SITEMPLATE.lib.wysihat.helpers.toggle_tag.query(editor, 'H2')
    }
    h3: {
      name: 'h3',
      label: '<i class="icon-h3"/>',
      init: (button) ->
        button.
          attr('rel', 'tooltip').
          attr('data-original-title', window.SITEMPLATE.lib.wysihat.local.getLocale().toolbar.h3).
          tooltip(window.SITEMPLATE.lib.wysihat.cfg.TOOLTIP_OPTIONS).
          addClass('btn btn-small')
        group = button.prevAll('.btn-group:first')
        button.appendTo group
      handler: (editor) ->
        window.SITEMPLATE.lib.wysihat.helpers.toggle_tag.handler(editor, 'H3')
      query: (editor) ->
        window.SITEMPLATE.lib.wysihat.helpers.toggle_tag.query(editor, 'H3')
    }
    block_left: {
      name: 'block_left',
      label: '<i class="icon-align-left"/>',
      init: (button) ->
        button.
          attr('rel', 'tooltip').
          attr('data-original-title', window.SITEMPLATE.lib.wysihat.local.getLocale().toolbar.align.left).
          tooltip(window.SITEMPLATE.lib.wysihat.cfg.TOOLTIP_OPTIONS).
          addClass('btn btn-small')
        group = $('<div/>').addClass('btn-group').insertBefore(button)
        button.appendTo group
      handler: (editor) ->
        selected = editor.find('.selected:first')
        if selected.length > 0
          window.SITEMPLATE.lib.wysihat.helpers.toggle_class.handler(editor, window.SITEMPLATE.lib.wysihat.cfg.IMAGE_ALIGN_CLASSES, 0)
        else
          window.SITEMPLATE.lib.wysihat.helpers.toggle_class.handler(editor, window.SITEMPLATE.lib.wysihat.cfg.BLOCK_ALIGN_CLASSES, 0)
      query: (editor) ->
        selected = editor.find('.selected:first')
        if selected.length > 0
          window.SITEMPLATE.lib.wysihat.helpers.toggle_class.query(editor, window.SITEMPLATE.lib.wysihat.cfg.IMAGE_ALIGN_CLASSES, 0)
        else
          window.SITEMPLATE.lib.wysihat.helpers.toggle_class.query(editor, window.SITEMPLATE.lib.wysihat.cfg.BLOCK_ALIGN_CLASSES, 0)
    }
    block_center: {
      name: 'block_center',
      label: '<i class="icon-align-center"/>',
      init: (button) ->
        button.
          attr('rel', 'tooltip').
          attr('data-original-title', window.SITEMPLATE.lib.wysihat.local.getLocale().toolbar.align.center).
          tooltip(window.SITEMPLATE.lib.wysihat.cfg.TOOLTIP_OPTIONS).
          addClass('btn btn-small')
        group = button.prevAll('.btn-group:first')
        button.appendTo group
      handler: (editor) ->
        selected = editor.find('.selected:first')
        if selected.length > 0
          window.SITEMPLATE.lib.wysihat.helpers.toggle_class.handler(editor, window.SITEMPLATE.lib.wysihat.cfg.IMAGE_ALIGN_CLASSES, 1)
        else
          window.SITEMPLATE.lib.wysihat.helpers.toggle_class.handler(editor, window.SITEMPLATE.lib.wysihat.cfg.BLOCK_ALIGN_CLASSES, 1)
      query: (editor) ->
        selected = editor.find('.selected:first')
        if selected.length > 0
          window.SITEMPLATE.lib.wysihat.helpers.toggle_class.query(editor, window.SITEMPLATE.lib.wysihat.cfg.IMAGE_ALIGN_CLASSES, 1)
        else
          window.SITEMPLATE.lib.wysihat.helpers.toggle_class.query(editor, window.SITEMPLATE.lib.wysihat.cfg.BLOCK_ALIGN_CLASSES, 1)
    }
    block_right: {
      name: 'block_right',
      label: '<i class="icon-align-right"/>',
      init: (button) ->
        button.
          attr('rel', 'tooltip').
          attr('data-original-title', window.SITEMPLATE.lib.wysihat.local.getLocale().toolbar.align.right).
          tooltip(window.SITEMPLATE.lib.wysihat.cfg.TOOLTIP_OPTIONS).
          addClass('btn btn-small')
        group = button.prevAll('.btn-group:first')
        button.appendTo group
      handler: (editor) ->
        selected = editor.find('.selected:first')
        if selected.length > 0
          window.SITEMPLATE.lib.wysihat.helpers.toggle_class.handler(editor, window.SITEMPLATE.lib.wysihat.cfg.IMAGE_ALIGN_CLASSES, 2)
        else
          window.SITEMPLATE.lib.wysihat.helpers.toggle_class.handler(editor, window.SITEMPLATE.lib.wysihat.cfg.BLOCK_ALIGN_CLASSES, 2)
      query: (editor) ->
        selected = editor.find('.selected:first')
        if selected.length > 0
          window.SITEMPLATE.lib.wysihat.helpers.toggle_class.query(editor, window.SITEMPLATE.lib.wysihat.cfg.IMAGE_ALIGN_CLASSES, 2)
        else
          window.SITEMPLATE.lib.wysihat.helpers.toggle_class.query(editor, window.SITEMPLATE.lib.wysihat.cfg.BLOCK_ALIGN_CLASSES, 2)
    }
    block_justify: {
      name: 'block_justify',
      label: '<i class="icon-align-justify"/>',
      init: (button) ->
        button.
          attr('rel', 'tooltip').
          attr('data-original-title', window.SITEMPLATE.lib.wysihat.local.getLocale().toolbar.align.justify).
          tooltip(window.SITEMPLATE.lib.wysihat.cfg.TOOLTIP_OPTIONS).
          addClass('btn btn-small')
        group = button.prevAll('.btn-group:first')
        button.appendTo group
      handler: (editor) ->
        selected = editor.find('.selected:first')
        if selected.length == 0
          window.SITEMPLATE.lib.wysihat.helpers.toggle_class.handler(editor, window.SITEMPLATE.lib.wysihat.cfg.BLOCK_ALIGN_CLASSES, 3)
      query: (editor) ->
        selected = editor.find('.selected:first')
        if selected.length == 0
          window.SITEMPLATE.lib.wysihat.helpers.toggle_class.query(editor, window.SITEMPLATE.lib.wysihat.cfg.BLOCK_ALIGN_CLASSES, 3)
    }
    ul: {
      name: 'ul',
      label: '<i class="icon-list"/>',
      init: (button) ->
        button.
          attr('rel', 'tooltip').
          attr('data-original-title', window.SITEMPLATE.lib.wysihat.local.getLocale().toolbar.ul).
          tooltip(window.SITEMPLATE.lib.wysihat.cfg.TOOLTIP_OPTIONS).
          addClass('btn btn-small')
        group = $('<div/>').addClass('btn-group').insertBefore(button)
        button.appendTo group
      handler: (editor) ->
        editor.handler.saveState()
        editor.toggleUnorderedList()
      query: (editor) ->
        editor.unorderedListSelected()
    }
    ol: {
      name: 'ol',
      label: '<i class="icon-ol"/>',
      init: (button) ->
        button.
          attr('rel', 'tooltip').
          attr('data-original-title', window.SITEMPLATE.lib.wysihat.local.getLocale().toolbar.ol).
          tooltip(window.SITEMPLATE.lib.wysihat.cfg.TOOLTIP_OPTIONS).
          addClass('btn btn-small')
        group = button.prevAll('.btn-group:first')
        button.appendTo group
      handler: (editor) ->
        editor.handler.saveState()
        editor.toggleOrderedList()
      query: (editor) ->
        editor.orderedListSelected()
    }
    image: {
      name: 'image',
      label: '<i class="icon-picture"/>',
      init: (button) ->
        button.
          attr('rel', 'tooltip').
          attr('data-original-title', window.SITEMPLATE.lib.wysihat.local.getLocale().toolbar.image).
          tooltip(window.SITEMPLATE.lib.wysihat.cfg.TOOLTIP_OPTIONS).
          addClass('btn btn-small')
        group = $('<div/>').addClass('btn-group').insertBefore(button)
        button.appendTo group
      handler: (editor) ->
        editor.handler.saveState()
        editor.handler.cfg.options.insertImageHandler(editor)
    }
    ###
    inline_left: {
      name: 'inline_left',
      label: '<i class="icon-pull-left"/>',
      init: (button) ->
        button.
          attr('rel', 'tooltip').
          attr('data-original-title', window.SITEMPLATE.lib.wysihat.local.getLocale().toolbar.inline.left).
          tooltip(window.SITEMPLATE.lib.wysihat.cfg.TOOLTIP_OPTIONS).
          addClass('btn btn-small')
        group = button.prevAll('.btn-group:first')
        button.appendTo group
      handler: (editor) ->
        window.SITEMPLATE.lib.wysihat.helpers.toggle_class.handler(editor, window.SITEMPLATE.lib.wysihat.cfg.INLINE_CLASSES, 0)
      query: (editor) ->
        window.SITEMPLATE.lib.wysihat.helpers.toggle_class.query(editor, window.SITEMPLATE.lib.wysihat.cfg.INLINE_CLASSES, 0)
    }
    inline_right: {
      name: 'inline_right',
      label: '<i class="icon-pull-right"/>',
      init: (button) ->
        button.
          attr('rel', 'tooltip').
          attr('data-original-title', window.SITEMPLATE.lib.wysihat.local.getLocale().toolbar.inline.right).
          tooltip(window.SITEMPLATE.lib.wysihat.cfg.TOOLTIP_OPTIONS).
          addClass('btn btn-small')
        group = button.prevAll('.btn-group:first')
        button.appendTo group
      handler: (editor) ->
        window.SITEMPLATE.lib.wysihat.helpers.toggle_class.handler(editor, window.SITEMPLATE.lib.wysihat.cfg.INLINE_CLASSES, 1)
      query: (editor) ->
        window.SITEMPLATE.lib.wysihat.helpers.toggle_class.query(editor, window.SITEMPLATE.lib.wysihat.cfg.INLINE_CLASSES, 1)
    }
    ###
    link: {
      name: 'link',
      label: '<i class="icon-link"/>',
      init: (button) ->
        button.
          attr('rel', 'tooltip').
          attr('data-original-title', window.SITEMPLATE.lib.wysihat.local.getLocale().toolbar.link).
          tooltip(window.SITEMPLATE.lib.wysihat.cfg.TOOLTIP_OPTIONS).
          addClass('btn btn-small')
        group = $('<div/>').addClass('btn-group').insertBefore(button)
        button.appendTo group
      handler: (editor) ->
        editor.handler.saveState()
        editor.handler.cfg.options.linkHandler(editor)
    }
    ###
    html: {
      name: 'html',
      label: '<i class="icon-html"/>',
      init: (button) ->
        button.
          attr('rel', 'tooltip').
          attr('data-original-title', window.SITEMPLATE.lib.wysihat.local.getLocale().toolbar.html).
          tooltip(window.SITEMPLATE.lib.wysihat.cfg.TOOLTIP_OPTIONS).
          addClass('btn btn-small')
        group = $('<div/>').addClass('btn-group').insertBefore(button)
        button.appendTo group
      handler: (editor) ->
        editor.handler.saveState()
        editor.handler.cfg.options.insertHTMLHandler(editor)
    }
    ###
    # save: {
    #   name: 'save',
    #   label: '<i class="icon-ok icon-white"/>',
    #   init: (button) ->
    #     button.
    #       attr('rel', 'tooltip').
    #       attr('data-original-title', window.SITEMPLATE.lib.wysihat.local.getLocale().toolbar.save).
    #       tooltip(window.SITEMPLATE.lib.wysihat.cfg.TOOLTIP_OPTIONS).
    #       addClass('btn btn-success')
    #     group = $('<div/>').addClass('btn-group').insertBefore(button)
    #     button.appendTo group
    #   handler: (editor) ->
    #     editor.handler.cfg.options.saveHandler(editor)
    # }
  }
  options:
    insertImageHandler: (editor) ->
      cfg = {
        callback: (image) -> editor.handler.insertImage(image.uploaded_file.custom.url)
      }
      SITEMPLATE.image_uploader.selectImage cfg

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
        cfg = editor.handler.cfg
        editor.focus()
        editor.insertHTML(cfg.options.beforePaste(cfg, value))
        editor.handler.adaptContent()

    saveHandler: (editor) ->
      form = editor.parents('form:first')
      form.submit()

    beforePaste: (cfg, text) ->
      div = $('<div></div>').
        addClass('hidden wym_paste_container').
        html(text).
        appendTo($('body'))

      s = new Sanitize(cfg.sanitize.basic)
      sanitized = s.clean_node(div[0])
      if sanitized
        div.empty()
        $(sanitized).appendTo(div)

      html = $('.wym_paste_container').html()
      $('.wym_paste_container').remove()
      html


