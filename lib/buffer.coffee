{CompositeDisposable} = require 'atom'

module.exports = class Buffer
  constructor: (@buffer, @destroyCallback) ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add @buffer.onDidDestroy @destroyCallback
    @subscriptions.add @buffer.onDidChange =>
      @changed = true
    @changed = true

  isChanged: -> @changed

  setChanged: (@changed) ->

  getPath: -> @buffer.getPath()

  getText: -> @buffer.getText()

  onDidDestroy: (callback) ->
    @subscriptions.add @buffer.onDidDestroy callback

  onDidChange: (callback) ->
    @subscriptions.add @buffer.onDidChange callback

  destroy: ->
    @subscriptions.dispose()
    @destroyCallback()
