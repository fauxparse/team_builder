class ManageEventOccurrence
  constructor: (props) ->
    @occurrence = m.prop(props.occurrence)
    @index = props.index

  view: ->
    klass = "occurrence"
    m("section", { class: klass, style: "left: #{@index * 100}%", key: @occurrence().url() },
      m("h2",
        @occurrence()?.starts_at().format(I18n.t("moment.long"))
      )
    )

App.Components.ManageEventOccurrence =
  controller: (args...) ->
    new ManageEventOccurrence(args...)

  view: (controller) ->
    controller.view()

