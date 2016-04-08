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
          ),
          m("div", { class: "date-and-time" },
            m.component(App.Components.DateTimePicker,
              I18n.t("activerecord.attributes.event.starts_at"),
              @event().starts_at,
              errors: => @event().errorsOn("starts_at")
            )
            m.component(App.Components.DateTimePicker,
              I18n.t("events.edit.until"),
              @stopsAt,
              errors: => []
              showDate: false
            )
          )
          m.component(App.Components.Checkbox,
            I18n.t("events.edit.repeat")
            @event().repeats
          )
          m("div", { class: "repeat-options" },
            m.component(App.Components.RadioButton,
              I18n.t("events.edit.repeats.weekly")
              @event().repeat_type
              name: "repeat_type"
              value: "weekly"
            )
            m.component(App.Components.RadioButton,
              =>
                I18n.t("events.edit.repeats.monthly_by_day",
                  day: moment.localeData().ordinal(@event().starts_at().date())
                )
              @event().repeat_type
              name: "repeat_type"
              value: "monthly_by_day"
            )
            m.component(App.Components.RadioButton,
              =>
                I18n.t("events.edit.repeats.monthly_by_week",
                  week: moment.localeData().ordinal(
                    Math.ceil(@event().starts_at().date() / 7)
                  ),
                  day: @event().starts_at().format("dddd")
                )
              @event().repeat_type
              name: "repeat_type"
              value: "monthly_by_week"
            )

          ) if @event().repeats()
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

  stopsAt: (value) =>
    start = @event().starts_at()
    if value?
      stop = start.clone()
      stop.hour(value.hour())
      stop.minute(value.minute())
      stop.add(1, "day") while stop.isBefore(start)
      @event().duration(stop.diff(start, "seconds"))
    start.clone().add(@event().duration(), "seconds")

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
