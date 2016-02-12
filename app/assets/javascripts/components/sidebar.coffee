class Sidebar
  constructor: (props) ->

  view: ->
    m("aside", {})

App.Components.Sidebar =
  controller: (args...) ->
    new Sidebar(args...)

  view: (controller) ->
    controller.view()
