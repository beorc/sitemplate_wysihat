window.SITEMPLATE = {} unless window.SITEMPLATE
SITEMPLATE.lib = {} unless SITEMPLATE.lib
window.SITEMPLATE.lib.wysihat = {} unless window.SITEMPLATE.lib.wysihat

window.SITEMPLATE.lib.wysihat.init = (editors, cfg) ->
  if (editors.length > 0)
    $.getScript '/jq-wysihat.js', () ->
      cfg = SITEMPLATE.lib.wysihat.cfg unless cfg
      SITEMPLATE.lib.wysihat.attach(editors, cfg)

window.SITEMPLATE.lib.wysihat.EDITOR_SELECTOR = '.sitemplate-rich-editor'

window.SITEMPLATE.lib.wysihat.instances = []

window.SITEMPLATE.lib.wysihat.attach = (editors, cfg) ->
  SITEMPLATE.image_uploader.initSelectImageDialog()
  SITEMPLATE.link_selector.init()
  editors.each (i, editor) ->
    handler = new SITEMPLATE.lib.wysihat.handler.EditorHandler(editor, cfg)
    SITEMPLATE.lib.wysihat.instances.push(handler)

window.SITEMPLATE.lib.wysihat.attachAll = (cfg) ->
  SITEMPLATE.lib.wysihat.attach($(SITEMPLATE.lib.wysihat.EDITOR_SELECTOR), cfg)

window.SITEMPLATE.lib.wysihat.initAll = (cfg) ->
  if ($(SITEMPLATE.lib.wysihat.EDITOR_SELECTOR).length > 0)
    $.getScript '/jq-wysihat.js', () ->
      cfg = SITEMPLATE.lib.wysihat.cfg unless cfg
      SITEMPLATE.lib.wysihat.attachAll(cfg)

