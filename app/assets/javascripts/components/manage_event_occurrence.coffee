class ManageEventOccurrence
  constructor: (props) ->
    @occurrence = m.prop(props.occurrence)
    @event = props.event
    @index = props.index
    @tab = props.tab

  view: =>
    klass = "occurrence"
    m("section",
      {
        class: klass,
        style: "left: #{@index * 100}%",
        key: @occurrence().url()
      },
      @[@tab()]()
    )

  times: ->
    if @occurrence().starts_at().isSame(@occurrence().stops_at(), "day")
      [
        m("span",
          @occurrence().starts_at().format(I18n.t("moment.time")) +
          " – " +
          @occurrence().stops_at().format(I18n.t("moment.time"))
        )
        @occurrence().stops_at().format(I18n.t("moment.long"))
      ]
    else
      [
        m("span", @occurrence().starts_at().format(I18n.t("moment.full")))
        m("span", @occurrence().stops_at().format(I18n.t("moment.full")))
      ]

  summary: ->
    [
      @myAvailability(),
      m("ul", { class: "details" },
        m("li",
          m("i", { class: "material-icons" }, "access_time")
          m("span", @times())
        )
      )
    ]

  myAvailability: ->
    buttons = [
      ["unavailable", "block"]
      ["possible", "help"]
      ["available", "check_circle"]
    ]
    selectedValue = @occurrence().availabilityFor(App.Models.Member.current())
    makeButton = (value, icon) =>
      id = "my-availability-#{value}"
      [
        m("input", {
          type: "radio"
          id: id
          name: "my-availability"
          value: value
          checked: value == selectedValue
        })
        m("label", { for: id, "data-value": value },
          m("i", { class: "material-icons" }, icon)
          m("small", I18n.t("availability.#{value}"))
        )
      ]
    m("div", { class: "my-availability" },
      (makeButton(button...) for button in buttons)
    )

  people: ->
    []

App.Components.ManageEventOccurrence =
  controller: (args...) ->
    new ManageEventOccurrence(args...)

  view: (controller) ->
    controller.view()

