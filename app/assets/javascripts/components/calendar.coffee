class Calendar extends App.Components.Section
  constructor: (props) ->
    @origin = m.prop(@weekStart(@dateFromParams()))
    @offset = m.prop(0)
    @index = m.prop(0)
    @selected = m.prop(null)
    @eventsForSelectedDate = m.prop([])
    @_window = 10
    @_rowHeight = 80
    @_weekAt = {}
    @_vertical = {}
    @doScroll = $.throttle(16, @doScroll)
    @title = m.prop("")

  view: ->
    @_today = moment().startOf("day")
    @updateSelected(@selected() || @weekAt(@index()))

    m("section", { class: "calendar" },
      m.component(App.Components.Header, title: @title)
      m("div",
        {
          class: "calendar-inner",
          onwheel: @wheel,
          onmousedown: @touchStart,
          onmousemove: @touchMove,
          onmouseup: @touchEnd,
          config: m.touchHelper(
            touchstart: @touchStart,
            touchmove: @touchMove,
            touchend: @touchEnd,
            tap: @tap
          )
        },
        m("div", { class: "weeks-container" },
          m("div", {
            class: "weeks",
            style: "#{$.support.transform}: translateY(#{-@offset()}px);"
          }, @renderWeeks())
        )
      )
    )

  updateSelected: (selected) ->
    @title(selected.format("MMMM YYYY"))
    path = "/calendar/" + selected.format("YYYY/MM")
    history.replaceState({}, "", @_path = path) unless @_path == path

  dateFromParams: ->
    if year = m.route.param("year")
      if month = m.route.param("month")
        moment("#{year}-#{month}", "YYYY-MM")
      else
        moment(year, "YYYY")
    else
      moment()

  weekAt: (index) ->
    @_weekAt[index] ?= if index == 0
      @origin()
    else if index < 1
      @weekStart(@weekAt(index + 1).clone().subtract(1, "day"))
    else
      @weekEnd(@weekAt(index - 1)).add(1, "day")

  weekStart: (date) ->
    d1 = date.clone().startOf("isoweek")
    d2 = date.clone().startOf("month")
    if d1.isAfter(d2) then d1 else d2

  weekEnd: (date) ->
    d1 = date.clone().endOf("isoWeek").startOf("day")
    d2 = date.clone().endOf("month").startOf("day")
    if d1.isBefore(d2) then d1 else d2

  verticalPosition: (index) ->
    @_vertical[index] ?= if index < 0
      margin = if @weekAt(index + 1).date() == 1 then 16 else 0
      @verticalPosition(index + 1) - 80 - margin
    else
      margin = if @weekAt(index).date() == 1 then 16 else 0
      base = if index == 0 then 0 else @verticalPosition(index - 1) + 80
      base + margin

  indexFromOffset: (offset) ->
    index = @index()
    while true
      if offset < @verticalPosition(index)
        index -= 1
      else if offset >= @verticalPosition(index + 1)
        index += 1
      else
        return index

  renderWeeks: ->
    range = [(@index() - @_window)..(@index() + @_window)]
    (@renderWeek(@weekAt(index), index) for index in range)

  renderWeek: (date, index) ->
    key = date.format("YYYY-MM-DD")
    dates = []
    d = date.clone()
    while true
      dates.push d.clone()
      d.add(1, "day")
      break if d.day() == 1 || !d.isSame(date, "month")

    selected = false
    selected = true for d in dates when d.isSame(@selected())
    klass = "week"
    klass += " selected" if selected
    monthStart = dates[0].date() == 1
    selectedCount = selected &&
      Math.min(@eventsForSelectedDate().length, 4) || 0

    if dates.length < 7 || monthStart
      klass += if monthStart then " month-start" else " month-end"
    m("section",
      {
        class: klass,
        key: "W" + key,
        style: "top: #{@verticalPosition(index)}px",
        "data-start-date": key,
        "data-index": index
        "data-event-count": selectedCount
      },
      (@renderDay(d) for d in dates)
      @renderEvents(selected)
    )

  renderDay: (date) ->
    key = date.format("YYYY-MM-DD")
    klass = "day"
    klass += " weekend" if date.day() in [0, 6]
    klass += " today" if date.isSame(@_today, "day")
    klass += " selected" if date.isSame(@selected())
    klass += " has-events" if @eventCount(date) > 0
    attrs = {
      class: klass,
      key: "D" + key,
      "data-date": key,
      "data-day": date.day()
    }
    attrs["data-month-name"] = date.format("MMMM") if date.date() == 1
    m("article", attrs,
      m("span", { class: "number" }, date.date())
    )

  renderEvents: (selected) ->
    contents = if selected
      events = @eventsForSelectedDate().slice(0, 3)
      m("div", { class: "selected-events-inner" },
        m("h4", @selected().format(I18n.t("moment.long")))
        m("ul",
          (@renderEvent(event) for event in events)
        )
        m("p", I18n.t("calendar.empty_day")) unless events.length
        m("p", { class: "more" },
          I18n.t("calendar.more", count: @eventsForSelectedDate().length - 3)
        ) if @eventsForSelectedDate().length > 3
      )
    else
      m("div", { class: "selected-events-inner" })

    m("section", { class: "selected-events" }, contents)

  renderEvent: (event) ->
    m("li",
      m("a", { href: "#" },
        m("i", { class: "material-icons" }, "event")
        m("span",
          m("span", { class: "name" }, event.name)
          m("span", { class: "times" },
            moment(event.starts_at).format(I18n.t("moment.time"))
            "–"
            moment(event.stops_at).format(I18n.t("moment.time"))
          )
        )
      )
    )

  scroll: (offset) ->
    offset = Math.round(offset)
    unless offset == @offset()
      @offset(offset)
      @doScroll()

  doScroll: ->
    m.computation =>
      @index(@indexFromOffset(@offset()))

  wheel: (e) =>
    @_amplitude = 0
    @scroll(@offset() + e.deltaY)

  touchStart: (e) =>
    @_pressed = true
    @_reference = @yPosition(e)
    @_velocity = @_amplitude = 0
    @_frame = @offset()
    @_timestamp = Date.now()
    clearInterval(@_ticker)
    @_ticker = setInterval(@track, 100)

  touchMove: (e) =>
    if @_pressed
      y = @yPosition(e)
      delta = @_reference - y
      @_reference = y
      @scroll(@offset() + delta)

  touchEnd: (e) =>
    @_pressed = false
    clearInterval(@_ticker)
    if @_velocity > 10 || @_velocity < -10
      @_amplitude = 0.8 * @_velocity
      @_target = Math.round(@offset() + @_amplitude)
      @_timestamp = Date.now()
      requestAnimationFrame(@autoScroll)

  track: =>
    now = Date.now()
    elapsed = now - @_timestamp
    @_timestamp = now
    delta = @offset() - @_frame
    @_frame = @offset()
    v = 1000 * delta / (1 + elapsed)
    @_velocity = 0.8 * v + 0.2 * @_velocity

  autoScroll: =>
    if @_amplitude
      elapsed = Date.now() - @_timestamp
      delta = -@_amplitude * Math.exp(-elapsed / 325)
      if delta > 0.5 || delta < -0.5
        @scroll(@_target + delta)
        requestAnimationFrame(@autoScroll)
      else
        @scroll(@_target)

  yPosition: (e) ->
    (e.targetTouches?[0] ? e).clientY

  tap: (e) =>
    m.computation =>
      day = $(e.target).closest(".day")
      if day.length
        e.preventDefault()
        e.stopPropagation()
        @eventsForSelectedDate([])
        if day.is(".selected")
          @_fetchEvents?.request().abort()
          @selected(null)
        else
          @selected(moment(day.data("date")))
          @fetchEvents(@selected()).then(@eventsForSelectedDate)

  eventCount: (date) ->
    @_eventCounts ||= {}
    key = date.format("YYYY-MM-DD")
    if @_eventCounts[key]?
      @_eventCounts[key]
    else
      @fetchEventCounts(date)
      0

  fetchEventCounts: (date) ->
    @_fetchEventCounts ||= {}
    @_fetchEventCounts[date.year() * 12 + date.month()] ||= m.request
      method: "GET"
      url: "/calendar/#{date.format("YYYY/MM")}"
    .then (data) =>
      m.computation =>
        @_eventCounts ||= {}
        $.extend(@_eventCounts, data)

  fetchEvents: (date) ->
    key = date.format("YYYY/MM/DD")
    unless @_fetchEvents?.key == key
      @_fetchEvents?.request().abort()
      request = m.prop()
      @_fetchEvents = m.request(
        url: "/calendar/#{key}"
        config: request
      )
      @_fetchEvents.request = request
    @_fetchEvents

App.Components.Calendar =
  controller: (props = {}) ->
    new Calendar(props)

  view: (controller) ->
    controller.view()
