class Dashboard extends App.Components.Section
  constructor: (props) ->

  view: ->
    m("div", { class: "dashboard" },
      m.component(App.Components.Header, title: -> "Dashboard"),
      m("div", { class: "dashboard-inner" },
        m("h1", "Hello world")
      )
    )

App.Components.Dashboard =
  controller: (args...) ->
    new Dashboard(args...)

  view: (controller) ->
    controller.view()
