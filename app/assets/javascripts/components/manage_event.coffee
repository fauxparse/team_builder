class ManageEvent extends App.Components.Section
  constructor: (props) ->
    @event = m.prop()
    #App.Models.Member.fetch(m.route.param("id")).then(@member)

  view: ->
    klass = "manage-event"
    m("section", { class: klass },
      m.component(App.Components.Header,
        title: => "Event"
      )
      m("div",
        { class: "manage-event-inner" }
      )
    )

App.Components.ManageEvent =
  controller: (args...) ->
    new ManageEvent(args...)

  view: (controller) ->
    controller.view()

