{spawn} = require 'child_process'
{createInterface} = require 'readline'
{Point, Range} = require 'atom'

module.exports = class Merlin
  process: null
  interface: null

  queue: null

  constructor: ->
    @restart()
    @queue = Promise.resolve()

  restart: ->
    path = atom.config.get('ocaml-merlin.merlinPath')
    args = atom.config.get('ocaml-merlin.merlinArguments')
    @interface?.close()
    @process?.kill()
    @process = spawn path, args
    @process.on 'error', (error) -> console.log error
    @process.on 'exit', (code) -> console.log "Merlin exited with code #{code}"
    console.log "Merlin process started, pid = #{@process.pid}"
    @interface = createInterface
      input: @process.stdout
      output: @process.stdin
      terminal: false

  close: ->
    @interface?.close()
    @process?.kill()

  query: (buffer, query) ->
    @queue = @queue.then =>
      new Promise (resolve, reject) =>
        jsonQuery = JSON.stringify
          context: ["auto", buffer.getPath()]
          query: query
        @interface.question jsonQuery + '\n', (answer) ->
          [kind, payload] = JSON.parse(answer)
          if kind is "return"
            resolve payload
          else
            reject Error(answer)

  position: (point) ->
    point = Point.fromObject point
    {line: point.row + 1, col: point.column}

  point: (position) ->
    new Point position.line - 1, position.col

  range: (start, end) ->
    new Range (@point start), (@point end)

  sync: (buffer) ->
    return Promise.resolve(true) unless buffer.isChanged()
    buffer.setChanged false
    @query buffer, ["tell", "start", "at", @position([0, 0])]
    .then => @query buffer, ["tell", "source-eof", buffer.getText()]

  type: (buffer, point) ->
    @sync(buffer).then =>
      @query buffer, ["type", "enclosing", "at", @position point]
      .then (types) =>
        types.map ({start, end, type, tail}) =>
          range: @range start, end
          type: type
          tail: tail

  complete: (buffer, point, prefix) ->
    @sync(buffer).then =>
      @query buffer, ["complete", "prefix", prefix,
                      "at", @position point, "with", "doc"]
      .then ({entries}) ->
        entries

  expand: (buffer, point, prefix) ->
    @sync(buffer).then =>
      @query buffer, ["expand", "prefix", prefix,
                      "at", @position point]
      .then ({entries}) ->
        entries

  occurrences: (buffer, point) ->
    @sync(buffer).then =>
      @query buffer, ["occurrences", "ident", "at", @position point]
      .then (occurrences) =>
        occurrences.map ({start, end}) =>
          @range start, end

  locate: (buffer, point, kind = 'ml') ->
    @sync(buffer).then =>
      @query buffer, ["locate", null, kind, "at", @position point]
      .then (result) =>
        new Promise (resolve, reject) =>
          if typeof result is 'string'
            reject result
          else
            resolve
              file: result.file
              point: @point result.pos

  enclosing: (buffer, point) ->
    @sync(buffer).then =>
      @query buffer, ["enclosing", @position point]
      .then (selections) =>
        selections.map ({start, end}) =>
          @range start, end

  errors: (buffer) ->
    @sync(buffer).then =>
      @query buffer, ["errors"]
      .then (errors) =>
        errors.map ({start, end, type, message}) =>
          range: if start? and end? then @range start, end else null
          type: type
          message: message
