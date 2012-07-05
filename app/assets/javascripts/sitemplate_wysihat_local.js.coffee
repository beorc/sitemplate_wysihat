window.SITEMPLATE = {} unless window.SITEMPLATE
SITEMPLATE.lib = {} unless SITEMPLATE.lib
window.SITEMPLATE.lib.wysihat = {} unless window.SITEMPLATE.lib.wysihat

window.SITEMPLATE.lib.wysihat.local =
  current_locale: 'ru'

  getLocale: () ->
    self = window.SITEMPLATE.lib.wysihat.local
    self[self.current_locale]

  ru:
    toolbar:
      undo: 'Отменить'
      redo: 'Повторить'
      bold: 'Полужирный'
      italic: 'Курсив'
      underline: 'Подчеркнутый'
      h1: 'Заголовок первого уровня'
      h2: 'Заголовок второго уровня'
      h3: 'Заголовок третьего уровня'
      align:
        left: 'Выравнивание по левому краю'
        right: 'Выравнивание по правому краю'
        center: 'Выравнивание по центру'
        justify: 'Выравнивание по ширине'
      ul: 'Маркированный список'
      ol: 'Нумерованный список'
      image: 'Вставить изображение'
      inline:
        left: 'Врезка изображения слева'
        right: 'Врезка изображения справа'
      link: 'Вставить ссылку'
      html: 'Вставить разметку HTML'
      save: 'Сохранить'

  en:
    toolbar:
      undo: 'Undo'
      redo: 'Redo'
      bold: 'Bold'
      italic: 'Italic'
      underline: 'Underlined'
      h1: 'Header 1'
      h2: 'Header 2'
      h3: 'Header 3'
      align:
        left: 'Align left'
        right: 'Align right'
        center: 'Align center'
        justify: 'Align justify'
      ul: 'Unordered list'
      ol: 'Ordered list'
      image: 'Insert image'
      inline:
        left: 'Left inline image'
        right: 'Right inline image'
      link: 'Link'
      html: 'Insert HTML'
      save: 'Save'
