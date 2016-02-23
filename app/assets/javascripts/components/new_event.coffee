class NewEvent
  constructor: (props = {}) ->
    @event = props.event || m.prop(new App.Models.Event)
    @open = m.prop(false)

  view: ->
    klass = "new-event-button"
    klass += " open" if @open()
    m("section", { class: klass },
      m.component(App.Components.Header,
        {
          title: -> "New event"
          left: =>
            m("button", { onclick: @toggle },
              m("i", { class: "material-icons" })
            )
        }
      )
    )

  toggle: =>
    @open(!@open())

App.Components.NewEvent =
  controller: ->
    new NewEvent

  view: (controller) ->
    controller.view()
