class Application
  constructor: (props = App.Components.Application.properties) ->
    moment.tz.setDefault(tzdetect.matches()[0])
    @sidebar = m.prop(false)

  component: (c) =>
    @_c = c if c?
    @_c || App.Components.Dashboard

  view: ->
    [
      m("input", {
        id: "show-sidebar",
        type: "checkbox",
        autocomplete: "off",
        onchange: @toggleSidebar
      }),
      m("div", { class: "container-inner" },
        m.component(App.Components.Sidebar, showing: @sidebar),
        m("main", config: @routes),
        m("label", for: "show-sidebar", class: "sidebar-scrim")
      )
    ]

  routes: (main, isInitialized) =>
    unless isInitialized
      m.route.mode = "pathname"
      m.route main, "/",
        "/teams": App.Components.Calendar
        "/calendar": App.Components.Calendar
        "/": App.Components.Dashboard

  toggleSidebar: (e) =>
    @sidebar(e.target.checked)

App.Components.Application =
  controller: ->
    new Application

  view: (controller) ->
    controller.view()
