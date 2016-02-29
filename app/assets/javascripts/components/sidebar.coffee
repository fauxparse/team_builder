class Sidebar
  constructor: (props = {}) ->
    @teams = m.prop([])
    $("#show-sidebar").on "change", (e) =>
      @opened() if e.target.checked

  opened: ->
    unless @_opened
      App.Models.Team.fetch().then(@teams) unless @teams().length
      @_opened = true

  view: ->
    [
      m("section",
        m("ul",
          @link("/", "Dashboard", "dashboard"),
          @link("/calendar", "Calendar", "event")
        )
      ),
      m("section", { class: "teams" },
        m("ul",
          (@renderTeam(team) for team in @teams())
        )
      )
    ]

  link: (route, title, icon) ->
    m("li", { class: if m.route() == route then "current" else "" }
      m("a", { href: route, config: m.route },
        m("i", { class: "material-icons" }, icon),
        m("span", title)
      )
    )

  renderTeam: (team) ->
    @link("/teams/#{team.slug()}", team.name(), "group_work")

App.Components.Sidebar =
  controller: (args...) ->
    new Sidebar(args...)

  view: (controller) ->
    controller.view()
