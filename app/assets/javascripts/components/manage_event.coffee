class ManageEvent extends App.Components.Section
  @TABS = [
    [ "summary", "Summary" ]
    [ "people", "People" ]
  ]

  constructor: (props) ->
    @event = m.prop()
    @index = m.prop(0)
    @tab = m.prop("summary")
    @_cache = {}

  view: ->
    klass = "manage-event"
    m("section", { class: klass },
      m.component(App.Components.Header,
        title: @title
        left: @backButton("/teams/#{m.route.param("team")}/calendar")
        right: @navigationButtons
        content: @tabs
      )
      m("div", { class: "manage-event-inner", config: @config },
        m("div",
          {
            class: "pages"
            style: "left: #{@index() * -100}%"
            config: (el) => @_pages = el
          },
          (@renderPage(@index() + offset) for offset in [-1..1])
        )
      )
    )

  tabs: =>
    m.component(App.Components.Tabs, tabs: @constructor.TABS, selected: @tab)

  config: (el, isInitialized) =>
    unless isInitialized
      id = if m.route.param("day")
        (m.route.param(key) for key in ["id", "year", "month", "day"]).join("/")
      else
        m.route.param("id")
      if id
        App.Models.Event.fetch(id).then (event) =>
          @event(event)
          @cache(0, event.occurrence())

  cache: (index, occurrence) ->
    @_cache[index] = occurrence
    @_cache[index - 1] ||= occurrence.buildPrevious() if occurrence.previous()
    @_cache[index + 1] ||= occurrence.buildNext() if occurrence.next()

  renderPage: (index) ->
    if @_cache[index]
      m.component(App.Components.ManageEventOccurrence, {
        occurrence: @_cache[index]
        event: @event
        index: index
        key: index
        tab: @tab
      })

  title: =>
    if @event()
      [
        @event().name(),
        m("small", @_cache[@index()].starts_at().format(I18n.t("moment.long")))
      ]
    else
      ""

  navigationButtons: =>
    if @event()
      isFirst = !@occurrence()?.previous()
      isLast = !@occurrence()?.next()
      [
        m("button", { rel: "prev", onclick: @previous, disabled: isFirst },
          m("i", { class: "material-icons" }, "chevron_left")
        )
        m("button", { rel: "next", onclick: @next, disabled: isLast },
          m("i", { class: "material-icons" }, "chevron_right")
        )
      ]

  next: =>
    @go(@index() + 1)

  previous: =>
    @go(@index() - 1)

  go: (index) ->
    $(@_pages)
      .transition(
        { left: "#{index * -100}%" },
        500,
        "easeOutCubic"
      )
    setTimeout =>
      m.computation => @index(index)
    , 500
    App.Models.Event.fetch(@_cache[index].toParam())
      .then (event) =>
        m.computation => @cache(index, event.occurrence())

  occurrence: ->
    @_cache[@index()]

App.Components.ManageEvent =
  controller: (args...) ->
    new ManageEvent(args...)

  view: (controller) ->
    controller.view()
