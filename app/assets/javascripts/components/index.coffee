#= require_self
#= require_tree .

App.Components = {}

class App.Components.Section
  onunload: =>
    $("#show-sidebar").prop("checked", false)
