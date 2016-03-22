#= require_self
#= require_tree .

App.Components = {}

class App.Components.Section
  onunload: ->
    document.getElementById("show-sidebar").checked = false
