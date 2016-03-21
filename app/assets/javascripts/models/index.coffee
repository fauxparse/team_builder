#= require_self
#= require_tree .

App.Models = {}

class App.Model
  constructor: (attrs = {}) ->
    @id = m.prop(attrs.id)
    @saving = m.prop(false)
    @errors = m.prop({})
    for attr in @constructor.attributes
      @[attr] = m.prop()
    @attributes(attrs)

  attributes: (attrs = {}) ->
    for own key, value of attrs
      (@[key] ?= m.prop())(value)
    @constructor.attributes.reduce (memo, attr) =>
      $.extend(memo, "#{attr}": @[attr]())
    , { id: @id() }

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
    @attributes()

  @configure: (name, attributes...) ->
    @name = name
    @attributes = attributes
    @instances = m.prop([])

  @refresh: (data) ->
    @instances(new this(attrs) for attrs in data)
    @_fetch?.resolve(@instances())
    @instances()

  @fetch: ->
    unless @_fetch
      @_fetch = m.deferred()
      m.request({ method: "get", url: @url() })
        .then(@refresh.bind(this))
    @_fetch.promise
