class Dashboard extends App.Components.Section
  constructor: (props) ->

  view: ->
    m("section", { class: "dashboard" },
      m.component(App.Components.Header, title: -> I18n.t("dashboard.title")),
      m("div", { class: "dashboard-inner" },
        m("h1", "Hello world")
      )
    )

App.Components.Dashboard =
  controller: (args...) ->
    new Dashboard(args...)

  view: (controller) ->
    controller.view()
