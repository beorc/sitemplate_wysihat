# TODO: Сделать метод инициализирующий неймспейсы.
window.SITEMPLATE = {} unless window.SITEMPLATE
window.SITEMPLATE.image_uploader = {} unless window.SITEMPLATE.image_uploader

dialogSelectButton = () ->
  $('#sitemplate-image-selection-dialog > .modal-footer > a.select')

# Объект содержит логику работы с табом загрузки с жесткого диска.
# Предназначен исключительно для структурирования кода.
FromHDDTab =
  # Показать и скрыть вращающийся индикатор загрузки изображения.
  showImageLoader: () ->
    $('#sitemplate-image-selection-dialog img.image-loader').show()
  hideImageLoader: () ->
    $('#sitemplate-image-selection-dialog img.image-loader').hide()
  clearPreview: () ->
    $("#sitemplate-image-selection-dialog .selected-file-preivew img").each () ->
      $(@).remove() unless $(@).hasClass 'image-loader'
  clearErrors: () ->
    $('#sitemplate-image-selection-dialog .control-group').removeClass('error')
    $('#sitemplate-image-selection-dialog .controls span.help-inline').remove()
  reset: () ->
    FromHDDTab.uploadedImage = null
    $("#sitemplate-image-selection-dialog form")[0].reset()
    FromHDDTab.clearPreview()
    FromHDDTab.clearErrors()
    FromHDDTab.hideImageLoader()
    dialogSelectButton().unbind('click')

  # Инициализация таба загрузки с жесткого диска. Вешаем хэндлеры на
  # начало и окончание ajax-запроса, чтобы показать лоадер и заполнить
  # превью в случае успешной загрузки изображения.
  init: () ->
    $('#sitemplate-image-selection-dialog .selected-file-preivew').click () ->
      $('#custom_image_uploaded_file').click()

    $('#custom_image_uploaded_file').change () ->
      $('#sitemplate-image-selection-dialog form').ajaxSubmit(
        beforeSubmit: (a,f,o) ->
          o.dataType = 'json'
          FromHDDTab.clearPreview()
          FromHDDTab.clearErrors()
          FromHDDTab.showImageLoader()
        complete: (xhr, status) ->
          FromHDDTab.hideImageLoader()
          response = $.parseJSON xhr.responseText

          # Кешируем информацию о загруженной картинке, для того, чтобы
          # сделать обновление параметров после того, как пользователь жмет
          # кнопку "Выбрать".
          # В один момент времени мы работаем только с одним диалогом и с одной
          # картинкой, так что если на странице используется несколько диалогов
          # для разных целей проблем быть не должно: FromHDDTab.uploadedImage
          # будет запоминаться текущим диалогом и не будет перетираться.
          FromHDDTab.uploadedImage = response

          if xhr.status == 200
            imgEl = $("<img></img>").attr('src', response.uploaded_file.thumb.url)
            $("#sitemplate-image-selection-dialog .selected-file-preivew").append imgEl
          else
            if response.width
              $('#sitemplate-image-selection-dialog .width .control-group').addClass('error')
            if response.height
              $('#sitemplate-image-selection-dialog .height .control-group').addClass('error')
            if response.uploaded_file
              control_group = $('#sitemplate-image-selection-dialog .uploaded_file .control-group')
              control_group.addClass('error')
              controls = control_group.find('.controls')
              $('<span/>').
                addClass('help-inline').
                text(response.uploaded_file[0]).
                appendTo(controls)
       )
window.SITEMPLATE.image_uploader.initSelectImageDialog = () ->
  return if $("#sitemplate-image-selection-dialog").size() == 0
  $('#sitemplate-image-selection-dialog > .modal-footer > a.cancel').click () ->
    $("#sitemplate-image-selection-dialog").modal('hide')
    false

  FromHDDTab.init()

# Передаем cfg.callback, который будет выполнен после того, как пользователь выбрал
# изображение и нажал 'ok'.
window.SITEMPLATE.image_uploader.selectImage = (cfg) ->
  FromHDDTab.reset()

  # FIXME: В отладочных целях. В будущем убрать.
  unless cfg && cfg.callback
    alert('callback not exist')
    return

  dialogSelectButton().click () ->
    cfg.callback(FromHDDTab.uploadedImage)
    $("#sitemplate-image-selection-dialog").modal('hide')
    false

  $("#sitemplate-image-selection-dialog").removeClass('hide')
  $("#sitemplate-image-selection-dialog").modal('show')
