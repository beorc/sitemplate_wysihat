# TODO: Сделать метод инициализирующий неймспейсы.
window.SITEMPLATE = {} unless window.SITEMPLATE
window.SITEMPLATE.link_selector = {} unless window.SITEMPLATE.link_selector

dialogSelectButton = () ->
  $('#sitemplate-insert-link-dialog > .modal-footer > a.select')

dialogUrlInput = () ->
  $("#sitemplate-insert-link-dialog input#url")

dialogContentInput = () ->
  $("#sitemplate-insert-link-dialog input#content")

dialogInNewWindowInput = () ->
  $("#sitemplate-insert-link-dialog input#open_in_new_window")

window.SITEMPLATE.link_selector =
  reset: () ->
    dialogUrlInput().val('')
    dialogContentInput().val('')
    dialogInNewWindowInput().prop('checked', true)

  selectLink: (cfg) ->
    dialogSelectButton().click () ->
      cfg.url = dialogUrlInput().val()
      cfg.content = dialogContentInput().val()
      cfg.open_in_new_window = dialogInNewWindowInput().prop('checked')
      cfg.callback()
      $("#sitemplate-insert-link-dialog").modal('hide')
      false

    SITEMPLATE.link_selector.reset()
    $("#sitemplate-insert-link-dialog").removeClass('hide')
    $("#sitemplate-insert-link-dialog").modal('show')

  init: () ->
    return if $("#sitemplate-insert-link-dialog").size() == 0
    $('#sitemplate-insert-link-dialog > .modal-footer > a.cancel').click () ->
      $("#sitemplate-insert-link-dialog").modal('hide')
      false

