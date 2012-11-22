# TODO: Сделать метод инициализирующий неймспейсы.
window.SITEMPLATE = {} unless window.SITEMPLATE
window.SITEMPLATE.image_uploader = {} unless window.SITEMPLATE.image_uploader

dialogSelectButton = () ->
  $('#select-image-dialog > .modal-footer > a.select')

# Объект содержит логику работы с табом загрузки с жесткого диска.
# Предназначен исключительно для структурирования кода.
FromHDDTab =
  # Показать и скрыть вращающийся индикатор загрузки изображения.
  showImageLoader: () ->
    $('#from-hdd img.image-loader').show()
  hideImageLoader: () ->
    $('#from-hdd img.image-loader').hide()
  clearPreview: () ->
    $("#from-hdd .selected-file-preivew img").each () ->
      $(@).remove() unless $(@).hasClass 'image-loader'
  reset: () ->
    FromHDDTab.uploadedImage = null
    $("#from-hdd form")[0].reset()
    FromHDDTab.clearPreview()
    FromHDDTab.hideImageLoader()
    dialogSelectButton().unbind('click')

  # Инициализация таба загрузки с жесткого диска. Вешаем хэндлеры на
  # начало и окончание ajax-запроса, чтобы показать лоадер и заполнить
  # превью в случае успешной загрузки изображения.
  init: () ->
    $('#from-hdd .selected-file-preivew').click () ->
      $('#custom_image_uploaded_file').click()

    $('#from-hdd form').bind 'ajax:before', (xhr) ->
      FromHDDTab.clearPreview()
      FromHDDTab.showImageLoader()
    $('#from-hdd form').bind 'ajax:complete', (xhr, data) ->
      FromHDDTab.hideImageLoader()
      response = $.parseJSON data.responseText

      # Кешируем информацию о загруженной картинке, для того, чтобы
      # сделать обновление параметров после того, как пользователь жмет
      # кнопку "Выбрать".
      # В один момент времени мы работаем только с одним диалогом и с одной
      # картинкой, так что если на странице используется несколько диалогов
      # для разных целей проблем быть не должно: FromHDDTab.uploadedImage
      # будет запоминаться текущим диалогом и не будет перетираться.
      FromHDDTab.uploadedImage = response

      if data.status == 200
        imgEl = $("<img></img>").attr('src', response.uploaded_file.custom.url)
        $("#from-hdd .selected-file-preivew").append imgEl
      else
        alert data.responseText

    $('#custom_image_uploaded_file').change () ->
      $('#select-image-dialog #from-hdd form').submit()

window.SITEMPLATE.image_uploader.initSelectImageDialog = () ->
  return if $("#select-image-dialog").size() == 0
  $('#select-image-dialog > .modal-footer > a.cancel').click () ->
    $("#select-image-dialog").modal('hide')
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
    $("#select-image-dialog").modal('hide')
    false

  $("#select-image-dialog").removeClass('hide')
  $("#select-image-dialog").modal('show')
