class NewTeam extends App.Components.Section
  constructor: (props) ->
    @team = m.prop(new App.Models.Team)

  view: ->
    klass = "new-team"
    klass += " saving" if @team().saving()
    m("div", { class: klass },
      m.component(App.Components.Header, title: -> "New Team"),
      m("div",
        m.component(App.Components.TeamEditor, team: @team),
        m("div",
          @saveButton()
        )
      )
    )

  saveButton: ->
    if @team().saving()
      m("button", { disabled: true }, "Saving…")
    else
      m("button", { onclick: @createClicked }, "Create team")

  createClicked: (e) =>
    m.computation =>
      @team().saving(true)
    setTimeout =>
      @team().save().then(@teamCreated, @teamCreationFailed)
    , 150

  teamCreated: =>
    m.redraw()
    m.route(@team().url())

  teamCreationFailed: =>
    m.redraw()

App.Components.NewTeam =
  controller: (args...) ->
    new NewTeam(args...)

  view: (controller) ->
    controller.view()
