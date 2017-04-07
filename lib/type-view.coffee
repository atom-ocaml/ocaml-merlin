{TextEditor} = require 'atom'
etch = require 'etch'
$ = etch.dom

module.exports = class TypeView
  @typeList: null
  @typeIndex: null

  @editor: null
  @marker: null

  @subscription: null

  constructor: (@typeList, @editor) ->
    @typeIndex = 0
    etch.initialize this
    @refs.editor.element.removeAttribute 'tabindex'

  render: ->
    $.div
      class: 'ocaml-merlin-type',
      $ TextEditor,
        ref: 'editor'
        mini: true
        grammar: atom.workspace.grammarRegistry.grammarForScopeName 'source.ocaml'
        autoHeight: true
        autoWidth: true

  update: ->
    etch.update this

  show: ->
    @destroy()
    {range, type} = @typeList[@typeIndex]
    @refs.editor.setText type
    @marker = @editor.markBufferRange range
    @editor.decorateMarker @marker,
      if range.isSingleLine() and type.split('\n').length < 10
        type: 'overlay'
        item: @element
        position: 'tail'
        class: 'ocaml-merlin'
      else
        type: 'block'
        item: @element
        position: 'after'
    @editor.decorateMarker @marker,
      type: 'highlight'
      class: 'ocaml-merlin'
    @subscription = @editor.onDidChangeCursorPosition => @destroy()
    type

  expand: ->
    return unless @typeIndex + 1 < @typeList?.length ? 0
    @typeIndex += 1
    @show()

  shrink: ->
    return unless @typeIndex > 0
    @typeIndex -= 1
    @show()

  destroy: ->
    # etch.destroy this
    # .then =>
    @marker?.destroy()
    @subscription?.dispose()
