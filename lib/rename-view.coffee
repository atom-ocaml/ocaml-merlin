{CompositeDisposable, Disposable, TextEditor} = require 'atom'
etch = require 'etch'
$ = etch.dom

module.exports = class RenameView
  constructor: ({@name, callback}) ->
    etch.initialize this
    @disposables = new CompositeDisposable
    @disposables.add atom.commands.add @element,
      'core:confirm': =>
        callback @refs.editor.getText()
        @destroy()
      'core:cancel': =>
        @destroy()
    handler = =>
      @destroy() if document.hasFocus()
    @refs.editor.element.addEventListener 'blur', handler
    @disposables.add new Disposable =>
      @refs.editor.element.removeEventListener 'blur', handler
    @panel = atom.workspace.addModalPanel item: @element
    @refs.editor.setText @name
    @refs.editor.selectAll()
    @refs.editor.element.focus()

  render: ->
    $.div
      class: 'ocaml-merlin-dialog',
      $.label
        class: 'icon icon-arrow-right',
        "Enter the new name for #{@name}.",
      $ TextEditor,
        ref: 'editor'
        mini: true

  update: ->
    etch.update this

  destroy: ->
    @disposables.dispose()
    etch.destroy this
    .then =>
      @panel.destroy()
      atom.workspace.getActivePane().activate()
