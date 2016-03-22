class ToDo extends App.Components.Section
  constructor: (props) ->

  view: ->
    m("section", { class: "dashboard" },
      m.component(App.Components.Header, title: -> "Work in progress"),
      m("div", { class: "dashboard-inner" },
        m("p", "This bit isn’t finished yet.")
      )
    )

App.Components.ToDo =
  controller: (args...) ->
    new ToDo(args...)

  view: (controller) ->
    controller.view()
