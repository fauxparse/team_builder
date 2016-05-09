class DateTimePicker
  constructor: (label, prop, options) ->
    @label = label
    @value = prop
    @options = options
    @_cache = {}

  view: ->
    m("div", { class: "date-time-picker" },
      m.component(App.Components.TextField,
        @dateLabel()
        @dateValue
        @dateInputOptions()
      ) unless @options.showDate == false
      m.component(App.Components.TextField,
        @timeLabel()
        @timeValue
        @timeInputOptions()
      ) unless @options.showTime == false
    )

  dateInputOptions: ->
    $.extend {}, {
      id: (@options.id + "_date" if @options.id)
      onblur: => m.computation => delete @_cache.date
      config: @configureDatePopup
    }, @options.date

  timeInputOptions: ->
    $.extend {}, {
      id: (@options.id + "_time" if @options.id)
      onblur: => m.computation => delete @_cache.time
      config: @configureTimePopup
    }, @options.time

  dateLabel: -> @label

  timeLabel: ->
    if @options.showDate == false
      @label
    else
      I18n.t("moment.time_picker.label")

  dateValue: (value) =>
    @setDate(value) if arguments.length
    @_cache.date ? @value().format(I18n.t("moment.date_picker.preferred"))

  setDate: (value) ->
    @setDateOrTime(value, "date")

  timeValue: (value) =>
    @setTime(value) if arguments.length
    @_cache.time ? @value().format(I18n.t("moment.time_picker.preferred"))

  setTime: (value) ->
    @setDateOrTime(value, "time")

  setDateOrTime: (value, type) ->
    m.computation =>
      datetime = if moment.isMoment(value)
        delete @_cache[type]
        value.clone()
      else
        @_cache[type] = value
        @parseDate(value, I18n.t("moment.#{type}_picker.accepted"))
      if datetime && datetime.isValid()
        fields = if type == "date"
          ["hour", "minute"]
        else
          ["year", "month", "date"]
        for field in fields
          datetime[field](@value()[field]())
        @value(datetime)

  parseDate: (value, formats) ->
    return value if moment.isMoment(value)
    for format in formats
      date = moment(value, format)
      return date if date.isValid()
    undefined

  configureDatePopup: (input, isInitialized) =>
    unless isInitialized
      datePopup = new Drop
        target: input
        openOn: "click"
        remove: true
        content: =>
          container = document.createElement('div')
          accessor = (value) =>
            @setDate(value) if arguments.length
            @value()
          m.mount(container, m.component(Calendar, { value: accessor }))
          container
        tetherOptions:
          attachment: "top left"
          targetAttachment: "bottom left"
          constraints:
            [
              {
                to: "scrollParent"
                pin: ["left", "right"]
                attachment: "together"
              }
            ]
      datePopup.on "open", -> input.focus()
      $(datePopup.content).on "click", ".day", -> datePopup.close()

  configureTimePopup: (input, isInitialized) =>
    unless isInitialized
      timePopup = new Drop
        target: input
        openOn: "click"
        remove: true
        content: =>
          container = document.createElement('div')
          accessor = (value) =>
            @setTime(value) if arguments.length
            @value()
          m.mount(container, m.component(Clock, { value: accessor }))
          container
        tetherOptions:
          attachment: "top right"
          targetAttachment: "bottom right"
          constraints:
            [
              {
                to: "scrollParent"
                pin: ["left", "right"]
                attachment: "together"
              }
            ]
      timePopup.on "open", -> input.focus()
      $(timePopup.content).on "click", ".day", -> timePopup.close()

Calendar =
  controller: (props) ->
    props.current = m.prop(props.value().clone())

  view: (controller, props) ->
    m("div", { class: "date-time-popup calendar-picker" },
      m("header",
        m("button", {
          onclick: (e) ->
            e.stopPropagation()
            props.current(props.current().clone().subtract(1, "month"))
        }, m("i", { class: "material-icons" }, "chevron_left"))
        m("span", props.current().format("MMMM YYYY"))
        m("button", {
          onclick: (e) ->
            e.stopPropagation()
            props.current(props.current().clone().add(1, "month"))
        }, m("i", { class: "material-icons" }, "chevron_right"))
      )
      m("section", { class: "weekday-headers" },
        (m("span", moment.localeData()._weekdaysMin[i % 7][0]) for i in [1..7])
      )
      m("section",
        @renderMonth(props.current().clone().startOf("month"), props)
      )
    )

  renderMonth: (date, props) ->
    result = []
    d = date.clone()
    today = moment()
    setValue = (value) -> (-> props.value(value))
    while d.isSame(date, "month")
      klass = "day"
      klass += " today" if d.isSame(today, "day")
      klass += " selected" if d.isSame(props.value(), "day")
      result.push(m("span", {
        "class": klass,
        "data-date": d.toISOString(),
        "data-day": d.day(),
        "onclick": setValue(d.clone())
      }, d.date()))
      d.add(1, "day")
    result

Clock =
  controller: (props) ->
    props.mode = m.prop("hours")

  view: (controller, props) ->
    time = props.value()
    switchMode = m.withAttr("rel", props.mode)
    m("div", { class: "date-time-popup clock-picker" },
      m("header", { class: "#{props.mode()} #{time.format("a")}" },
        m("button", { rel: "hours", onclick: switchMode }, time.format("h"))
        m("span", ":")
        m("button", { rel: "minutes", onclick: switchMode }, time.format("mm"))
        m("button", { rel: "am", onclick: @ampm.bind(this, props, 0) }, "AM")
        m("button", { rel: "pm", onclick: @ampm.bind(this, props, 12) }, "PM")
      )
      m("section")
    )

  ampm: (props, offset = 0) ->
    m.computation ->
      time = props.value().clone()
      time.hours(time.hours() % 12 + offset)
      props.value(time)

App.Components.DateTimePicker =
  controller: (args...) ->
    new DateTimePicker(args...)

  view: (controller) ->
    controller.view()
