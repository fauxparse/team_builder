class ManageEvent extends App.Components.Section
  constructor: (props) ->
    @event = m.prop()
    id = if m.route.param("day")
      (m.route.param(key) for key in ["id", "year", "month", "day"]).join("/")
    else
      m.route.param("id")
    App.Models.Event.fetch(id).then(@event)

  view: ->
    klass = "manage-event"
    m("section", { class: klass },
      m.component(App.Components.Header,
        title: @title
        left: @backButton("/teams/#{m.route.param("team")}/calendar")
      )
      m("div",
        { class: "manage-event-inner" }
      )
    )

  title: =>
    if @event()
      [
        @event().name(),
        m("small",
          @event().occurrence().starts_at().format(I18n.t("moment.long"))
        )
      ]
    else
      ""

App.Components.ManageEvent =
  controller: (args...) ->
    new ManageEvent(args...)

  view: (controller) ->
    controller.view()

