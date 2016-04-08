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
        onblur: => m.computation => delete @_cache.date
      ) unless @options.showDate == false
      m.component(App.Components.TextField,
        @timeLabel()
        @timeValue
        onblur: => m.computation => delete @_cache.time
      ) unless @options.showTime == false
    )

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
      if datetime
        fields = if type == "date"
          ["hour", "minute"]
        else
          ["year", "month", "day"]
        for field in fields
          datetime[field](@value()[field]())
        @value(datetime)

  parseDate: (value, formats) ->
    return value if moment.isMoment(value)
    for format in formats
      date = moment(value, format)
      return date if date.isValid()
    undefined

App.Components.DateTimePicker =
  controller: (args...) ->
    new DateTimePicker(args...)

  view: (controller) ->
    controller.view()
