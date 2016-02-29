class Sidebar
  constructor: (props = {}) ->
    @showing = props.showing
    @teams = m.prop([])

  view: ->
    if @showing()
      App.Models.Team.fetch().then(@teams)

    m("aside", {},
      m("section",
        m("ul",
          m("li",
            m("a[href=/]", { config: m.route }, "Dashboard")
          )
        )
      )
      m("section", { class: "teams" },
        m("ul",
          (@renderTeam(team) for team in @teams())
        )
      )
    )

  renderTeam: (team) ->
    m("li",
      m("a[href=/teams/#{team.slug()}]", { config: m.route },
        team.name()
      )
    )

App.Components.Sidebar =
  controller: (args...) ->
    new Sidebar(args...)

  view: (controller) ->
    controller.view()
