{View, TextEditorView} = require 'atom-space-pen-views'

module.exports = class RenameView extends View
  @content: ({name}) ->
    @div class: 'ocaml-merlin-dialog', =>
      @label "Enter the new name for #{name}.", class: 'icon icon-arrow-right'
      @subview 'miniEditor', new TextEditorView mini: true

  initialize: ({name, callback}) ->
    atom.commands.add @element,
      'core:confirm': =>
        callback @miniEditor.getText()
        @close()
      'core:cancel': =>
        @close()
    @miniEditor.on 'blur', =>
      @close() if document.hasFocus()
    @panel = atom.workspace.addModalPanel item: @element
    @miniEditor.setText name
    @miniEditor.getModel().selectAll()
    @miniEditor.focus()

  close: ->
    @panel?.destroy()
    atom.workspace.getActivePane().activate()
