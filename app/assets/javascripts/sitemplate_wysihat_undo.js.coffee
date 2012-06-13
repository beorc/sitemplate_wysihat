window.SITEMPLATE = {} unless window.SITEMPLATE
SITEMPLATE.lib = {} unless SITEMPLATE.lib
window.SITEMPLATE.lib.wysihat = {} unless window.SITEMPLATE.lib.wysihat

window.SITEMPLATE.lib.wysihat.undo =
  Undo: class 
    DEPTH: 10

    constructor: (handler) ->
      self = @
      @handler = handler
      handler.undo = @

      @states = []
      @current_state = -1 
      @keys_counter = 0

      @handler.editor.keyup () ->
        KEYS_TO_SAVE = 7 
        ++self.keys_counter
        if self.keys_counter > KEYS_TO_SAVE
          self.handler.saveState()
          self.keys_counter = 0
      return @

    isPresent: () ->
      @current_state == @states.length - 1

    haveUnsaved: () ->
      @isPresent() && @handler.content() != @states[@current_state]

    push: () ->
      return unless @haveUnsaved()

      ++@current_state

      if (@current_state < @states.length - 1)
        @states.splice @current_state, @states.length - @current_state
      if @current_state > @DEPTH
        @states.shift()

      @states.push @handler.content()

    undo: () ->
      if (@hasUndo())
        if @haveUnsaved()
          @push()
        --@current_state
        @handler.setContent @states[@current_state]

    redo: () ->
      if (@hasRedo())
        @current_state++
        @handler.setContent @states[@current_state]

    hasRedo: () ->
      !@isPresent() 

    hasUndo: () ->
      @current_state > 0


