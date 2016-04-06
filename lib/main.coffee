{CompositeDisposable} = require 'atom'

Merlin = null
Buffer = null
TypeView = null
SelectionView = null

module.exports =
  merlin: null
  subscriptions: null
  buffers: {}

  typeView: null
  selectionView: null

  occurrences: null

  returnToFile: null
  returnToPoint: null

  activate: (state) ->
    Merlin = require './merlin'
    Buffer = require './buffer'
    TypeView = require './type-view'
    SelectionView = require './selection-view'

    @merlin = new Merlin

    @subscriptions = new CompositeDisposable

    @subscriptions.add atom.config.onDidChange 'ocaml-merlin.merlinPath', =>
      buffer.setChanged true for _, buffer of @buffers
      @merlin.restart()

    @subscriptions.add atom.config.onDidChange 'ocaml-merlin.merlinArguments',=>
      buffer.setChanged true for _, buffer of @buffers
      @merlin.restart()

    target = 'atom-text-editor[data-grammar="source ocaml"]'
    @subscriptions.add atom.commands.add target,
      'ocaml-merlin:show-type': => @showType()
      'ocaml-merlin:shrink-type': => @typeView?.shrink()
      'ocaml-merlin:expand-type': => @typeView?.expand()
      'ocaml-merlin:close-bubble': => @typeView?.destroy()
      'ocaml-merlin:next-occurrence': => @getOccurrence(1)
      'ocaml-merlin:previous-occurrence': => @getOccurrence(-1)
      'ocaml-merlin:go-to-declaration': => @goToDeclaration('ml')
      'ocaml-merlin:go-to-type-declaration': => @goToDeclaration('mli')
      'ocaml-merlin:return-from-declaration': => @returnFromDeclaration()
      'ocaml-merlin:shrink-selection': => @shrinkSelection()
      'ocaml-merlin:expand-selection': => @expandSelection()

    @subscriptions.add atom.workspace.observeTextEditors (editor) =>
      @subscriptions.add editor.observeGrammar (grammar) =>
        if grammar.scopeName == 'source.ocaml'
          @addBuffer editor.getBuffer()
        else
          @removeBuffer editor.getBuffer()

  addBuffer: (textBuffer) ->
    bufferId = textBuffer.getId()
    return if @buffers[bufferId]?
    @buffers[bufferId] = new Buffer textBuffer, => delete @buffers[bufferId]

  removeBuffer: (textBuffer) ->
    @buffers[textBuffer.getId()]?.destroy()

  getBuffer: (editor) ->
    @buffers[editor.getBuffer().getId()]

  showType: ->
    return unless editor = atom.workspace.getActiveTextEditor()
    @merlin.type @getBuffer(editor), editor.getCursorBufferPosition()
    .then (typeList) =>
      @typeView?.destroy()
      return unless typeList.length
      @typeView = new TypeView typeList, editor
      @typeView.show()

  getOccurrence: (offset) ->
    return unless editor = atom.workspace.getActiveTextEditor()
    point = editor.getCursorBufferPosition()
    @merlin.occurrences @getBuffer(editor), point
    .then (ranges) ->
      index = ranges.findIndex (range) -> range.containsPoint point
      range = ranges[(index + offset) % ranges.length]
      editor.setSelectedBufferRange range

  goToDeclaration: (kind) ->
    return unless editor = atom.workspace.getActiveTextEditor()
    @returnToFile = editor.getPath()
    @returnToPoint = editor.getCursorBufferPosition()
    @merlin.locate @getBuffer(editor), @returnToPoint, kind
    .then ({file, point}) ->
      if file?
        atom.workspace.open file,
          initialLine: point.row
          initialColumn: point.column
          pending: true
          searchAllPanes: true
      else
        editor.setCursorBufferPosition point
    , (reason) ->
      atom.workspace.notificationManager.addError reason

  returnFromDeclaration: ->
    return unless @returnToFile?
    atom.workspace.open @returnToFile,
      initialLine: @returnToPoint.row
      initialColumn: @returnToPoint.column
      pending: true
      searchAllPanes: true
    @returnToFile = null
    @returnToPoint = null

  getSelectionView: ->
    return Promise.resolve(@selectionView) if @selectionView?.isAlive()
    return unless editor = atom.workspace.getActiveTextEditor()
    @merlin.enclosing @getBuffer(editor), editor.getCursorBufferPosition()
    .then (ranges) =>
      @selectionView ?= new SelectionView editor, ranges

  shrinkSelection: ->
    @getSelectionView().then (selectionView) -> selectionView.shrink()

  expandSelection: ->
    @getSelectionView().then (selectionView) -> selectionView.expand()

  deactivate: ->
    @merlin.close()
    @subscriptions.dispose()
    buffer.destroy() for _, buffer of @buffers

  getPrefix: (editor, point) ->
    line = editor.getTextInBufferRange([[point.row, 0], point])
    line.match(/[^\s\[\](){}<>,+*\/-]*$/)[0]

  provideAutocomplete: ->
    kindToType =
      "Value": "value"
      "Variant": "variable"
      "Constructor": "class"
      "Label": "keyword"
      "Module": "method"
      "Signature": "type"
      "Type": "type"
      "Method": "property"
      "#": "constant"
      "Exn": "keyword"
      "Class": "class"
    selector: '.source.ocaml'
    getSuggestions: ({editor, bufferPosition}) =>
      prefix = @getPrefix editor, bufferPosition
      return [] if prefix.length == 0
      @merlin.complete @getBuffer(editor), bufferPosition, prefix
      .then (entries) ->
        entries.map ({name, kind, desc, info}) ->
          text: name
          replacementPrefix: prefix
          type: kindToType[kind]
          leftLabel: kind
          rightLabel: desc
          description: if info.length then info else desc
    inclusionPriority: 1
    excludeLowerPriority: true

  provideLinter: ->
    name: 'OCaml Merlin'
    grammarScopes: ['source.ocaml']
    scope: 'file'
    lintOnFly: false
    lint: (editor) =>
      @merlin.errors @getBuffer(editor)
      .then (errors) ->
        errors.map ({range, type, message}) ->
          type: if type == 'warning' then 'Warning' else 'Error'
          text: message
          filePath: editor.getPath()
          range: range
          severity: if type == 'warning' then 'warning' else 'error'
