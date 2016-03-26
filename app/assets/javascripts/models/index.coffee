#= require_self
#= require_tree .

App.Models = {}

class App.Model
  constructor: (attrs = {}) ->
    @id = m.prop(attrs.id)
    @saving = m.prop(false)
    @errors = m.prop({})
    for attr in @constructor.attributes
      @[attr] ||= m.prop()
    @attributes(attrs)

  attributes: (attrs = {}) ->
    self = this
    for own key, value of attrs
      (@[key] ?= m.prop()).call(self, value)
    @constructor.attributes.reduce (memo, attr) =>
      memo[attr] = @[attr]()
      memo
    , { id: @id() }

  dateTimeAttribute: (name) ->
    cache = (@_dateTimeAttributes ||= {})[name] ||= m.prop()
    @[name] = (value) ->
      cache(moment(value)) if value?
      cache()

  toParam: -> @id()

  url: ->
    if @id()
      @constructor.url() + "/" + @toParam()
    else
      @constructor.url()

  hasErrors: ->
    !$.isEmptyObject(@errors() || {})

  allErrors: ->
    results = []
    for own attr, errors of @errors()
      results.splice(results.length, 0, errors...)
    results

  errorsOn: (attr) ->
    (@errors() || {})[attr] || []

  form: (attrs, contents...) ->
    defaults =
      method: @formMethod()
      url: @url()
      onsubmit: (e) -> e.preventDefault()
    m("form", $.extend(defaults, attrs), contents...)

  formMethod: ->
    @id() && "PUT" || "POST"

  save: ->
    m.computation =>
      @saving(m.deferred())
      m.request(url: @url(), method: @formMethod(), data: @asJSON())
        .then(@ajaxSuccess, @ajaxFailure)
    @saving().promise

  ajaxSuccess: (data = {}) =>
    @attributes(data)
    promise = @saving()
    m.computation => @saving(false)
    promise.resolve(this)

  ajaxFailure: (data = {}) =>
    @errors(data.errors || [])
    promise = @saving()
    m.computation => @saving(false)
    promise.reject(this)

  asJSON: ->
    json = {}
    for own key, value of @attributes()
      json[key] = if value?.asJSON?
        value.asJSON()
      else if @_dateTimeAttributes?[key]
        value.toISOString()
      else
        value
    json

  @configure: (name, attributes...) ->
    @name = name
    @attributes = attributes
    @instances = m.prop([])

  @refresh: (data) ->
    if $.isArray(data)
      @instances(new this(attrs) for attrs in data)
      @instances()
    else
      new this(data)

  @fetch: (args...) ->
    @_fetch ?= {}
    options = if args.length && $.isPlainObject(args[args.length - 1])
      args.pop()
    else
      {}
    id = args.shift()
    key = id || "all"
    unless @_fetch[key]
      @_fetch[key] = m.deferred()
      url = options.url || @url()
      url += "/" + id if id?
      url += "?_cache=false" unless options.allowCache
      m.request({ method: "get", url: url })
        .then (data) =>
          @_fetch[key].resolve(@refresh(data))
    @_fetch[key].promise
