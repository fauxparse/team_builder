class NewTeam extends App.Components.Section
  constructor: (props) ->
    @team = m.prop(new App.Models.Team)

  view: ->
    m("div", { class: "new-team" },
      m.component(App.Components.Header, title: -> "New Team"),
      m("div",
        m.component(App.Components.TeamEditor, team: @team),
        m("div",
          m("button", { onclick: @createClicked }, "Create team")
        )
      )
    )

  createClicked: (e) =>
    @team().save().then(@teamCreated, @teamCreationFailed)

  teamCreated: =>
    m.route(@team().url())

  teamCreationFailed: =>

App.Components.NewTeam =
  controller: (args...) ->
    new NewTeam(args...)

  view: (controller) ->
    controller.view()
