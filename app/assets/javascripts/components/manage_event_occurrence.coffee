class ManageEventOccurrence
  constructor: (props) ->
    @occurrence = m.prop(props.occurrence)
    @event = props.event
    @index = props.index

  view: =>
    klass = "occurrence"
    m("section",
      {
        class: klass,
        style: "left: #{@index * 100}%",
        key: @occurrence().url()
      },
      m("ul", { class: "details" },
        m("li",
          m("i", { class: "material-icons" }, "access_time")
          m("span", @times())
        )
      )
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


App.Components.ManageEventOccurrence =
  controller: (args...) ->
    new ManageEventOccurrence(args...)

  view: (controller) ->
    controller.view()

