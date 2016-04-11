module.exports = class SelectionView
  @editor: null

  @rangeList: null
  @rangeIndex: null

  @alive: null
  @subscription: null

  constructor: (@editor, @rangeList) ->
    @alive = true
    currentRange = @editor.getSelectedBufferRange()
    @rangeIndex = rangeList.findIndex (range) ->
      range.containsRange currentRange
    if not @rangeList[@rangeIndex].isEqual currentRange
      @rangeIndex -= 0.5
    @subscription =
      @editor.onDidChangeSelectionRange ({newBufferRange}) =>
        return if newBufferRange.isEqual @rangeList[@rangeIndex]
        @rangeIndex = @rangeList.findIndex (range) ->
          range.isEqual(newBufferRange)
        @destroy() if @rangeIndex is -1

  expand: ->
    newIndex = Math.floor @rangeIndex + 1
    return unless newIndex < @rangeList?.length ? 0
    @rangeIndex = newIndex
    @editor.setSelectedBufferRange @rangeList[@rangeIndex]

  shrink: ->
    newIndex = Math.ceil @rangeIndex - 1
    return unless newIndex >= 0
    @rangeIndex = newIndex
    @editor.setSelectedBufferRange @rangeList[@rangeIndex]

  isAlive: ->
    @alive

  destroy: ->
    @alive = false
    @subscription?.dispose()
