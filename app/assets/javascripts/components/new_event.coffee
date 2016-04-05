class NewEvent extends App.Components.Section
  constructor: (props = {}) ->
    @event = props.event || m.prop(new App.Models.Event.blank())
    @_autoUpdateSlug = !@event().id()

  view: ->
    m("section", { class: "new-event" },
      m.component(App.Components.Header,
        {
          title: -> I18n.t("events.new.title")
        }
      )
      m("div", { class: "new-event-inner" },
        @event().form({ class: "event-editor" },
          m.component(App.Components.TextField,
            I18n.t("activerecord.attributes.event.name"),
            @event().name,
            name: "event[name]",
            oninput: @nameChanged,
            errors: => @event().errorsOn("name")
          ),
          m.component(App.Components.URLField,
            "",
            @event().slug,
            name: "event[slug]",
            root: @eventsURL(),
            oninput: @slugChanged,
            errors: => @event().errorsOn("slug")
          )
        )
      )
    )

  eventsURL: ->
    "/teams/#{m.route.param("team")}/events/"

  nameChanged: (e) =>
    @event().name(e.target.value.trim())
    @check()

  slugChanged: (e) =>
    @event().slug(e.target.value.trim())
    @_autoUpdateSlug = false
    @check()

  check: ->
    clearTimeout(@_check)
    @_check = setTimeout =>
      attrs = @event().asJSON()
      delete attrs.slug if @_autoUpdateSlug
      @event().check(attrs).then =>
        console.log(@event().slug())
        m.redraw()
    , 250

App.Components.NewEvent =
  controller: ->
    new NewEvent

  view: (controller) ->
    controller.view()
