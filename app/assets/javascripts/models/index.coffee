#= require_self
#= require_tree .

App.Models = {}

class App.Model
  constructor: (attrs = {}) ->
    for own key, value of attrs
      (@[key] ?= m.prop())(value)
