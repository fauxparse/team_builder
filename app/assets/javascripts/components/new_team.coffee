class NewTeam extends App.Components.Section
  constructor: (props) ->
    @team = m.prop(new App.Models.Team)

  view: ->
    klass = "new-team"
    klass += " saving" if @team().saving()
    m("section", { class: klass },
      m.component(App.Components.Header, title: -> I18n.t("teams.new.title")),
      m("div", { class: "new-team-inner" },
        m.component(App.Components.TeamEditor, team: @team),
        m("div",
          @saveButton()
        )
      )
    )

  saveButton: ->
    if @team().saving()
      m("button", { disabled: true }, I18n.t("common.saving"))
    else
      m("button", { onclick: @createClicked }, I18n.t("teams.new.save"))

  createClicked: (e) =>
    m.computation =>
      @team().saving(true)
    setTimeout =>
      @team().save().then(@teamCreated, @teamCreationFailed)
    , 150

  teamCreated: =>
    m.redraw()
    m.route(@team().url())

  teamCreationFailed: ->
    m.redraw()

App.Components.NewTeam =
  controller: (args...) ->
    new NewTeam(args...)

  view: (controller) ->
    controller.view()
