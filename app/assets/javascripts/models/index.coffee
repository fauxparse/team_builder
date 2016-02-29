#= require_self
#= require_tree .

App.Models = {}

class App.Model
  constructor: (attrs = {}) ->
    for own key, value of attrs
      (@[key] ?= m.prop())(value)

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
