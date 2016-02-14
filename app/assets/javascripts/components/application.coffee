class Application
  constructor: (props = App.Components.Application.properties) ->
    moment.tz.setDefault(tzdetect.matches()[0]);

  view: ->
    [
      m("input", { id: "show-sidebar", type: "checkbox", autocomplete: "off" }),
      m("div", { class: "container-inner" },
        m.component(App.Components.Sidebar, {}),
        m.component(App.Components.Calendar, {}),
        m("label", { for: "show-sidebar", class: "material-icons sidebar-toggle" }),
        m("label", { for: "show-sidebar", class: "sidebar-scrim" })
      )
    ]

App.Components.Application =
  controller: ->
    new Application

  view: (controller) ->
    controller.view()