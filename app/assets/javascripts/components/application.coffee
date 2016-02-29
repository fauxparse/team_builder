class Application
  constructor: (props = App.Components.Application.properties) ->
    moment.tz.setDefault(tzdetect.matches()[0])

  view: ->
    [
      m("input", { id: "show-sidebar", type: "checkbox", autocomplete: "off" }),
      m("div", { class: "container-inner" },
        m.component(App.Components.Sidebar, {}),
        m("main", config: @routes),
        m("label", { for: "show-sidebar", class: "sidebar-scrim" })
      )
    ]
    
  routes: (main, isInitialized) =>
    unless isInitialized
      m.route.mode = "pathname"
      m.route main, "/",
        "/calendar": App.Components.Calendar
        "/": App.Components.Dashboard

App.Components.Application =
  controller: ->
    new Application

  view: (controller) ->
    controller.view()
