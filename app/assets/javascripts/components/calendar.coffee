class Calendar
  constructor: (props) ->
    @origin = m.prop(@weekStart(moment()))
    @_index = 0
    @_window = 10
    @_rowHeight = 80
    @_weekAt = {}
    @_vertical = {}

  view: ->
    m("div", { class: "calendar" },
      m("div", { class: "weeks-container" },
        m("div", { class: "weeks" }, @renderWeeks())
      )
    )

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

  renderWeeks: ->
    range = [(@_index - @_window)..(@_index + @_window)]
    (@renderWeek(@weekAt(index), index) for index in range)

  renderWeek: (date, index) ->
    key = date.format("YYYY-MM-DD")
    dates = []
    d = date.clone()
    while true
      dates.push d.clone()
      d.add(1, "day")
      break if d.day() == 1 || !d.isSame(date, "month")
    klass = "week"
    monthStart = dates[0].date() == 1
    if dates.length < 7 || monthStart
      klass += if monthStart then " month-start" else " month-end"
    m("section", {
      class: klass,
      key: "W" + key,
      style: "top: #{@verticalPosition(index)}px",
      "data-start-date": key,
      "data-index": index
    }, (@renderDay(d) for d in dates))

  renderDay: (date) ->
    key = date.format("YYYY-MM-DD")
    klass = "day"
    klass += " weekend" if date.day() in [0, 6]
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

App.Components.Calendar =
  controller: ->
    new Calendar

  view: (controller) ->
    controller.view()
