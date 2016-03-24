class Sidebar
  constructor: (props = {}) ->
    @member = m.prop(props.member && new App.Models.Member(props.member))
    @team = m.prop(props.team && new App.Models.Team(props.team))
    @teams = m.prop([])
    @showTeams = m.prop(false)

  view: ->
    klass = "profile"
    klass += " show-teams" if @showTeams()
    [
      m("header", { class: klass },
        m("div", { class: "profile-photo" },
          m("img", { src: @member()?.avatar() })
        )
        m("a",
          {
            class: "team-selector", href: "/teams", onclick: @toggleTeams
          },
          m("span", { class: "member-name" }, @member().name()) if @member()
          m("span", { class: "team-name" },
            @team()?.name() || I18n.t("teams.none")
          )
          m("i", { class: "material-icons" }, "arrow_drop_down")
        )
      )
      m("section", { class: "team-links" },
        m("ul",
          @teamLinks(@team())
          @logoutLink()
        )
      )
      m("section", { class: "teams-list", onclick: @hideTeams },
        m("ul",
          (@teamLink(team) for team in @teams())
          @link("/teams/new", I18n.t("teams.new.title"), "add")
        )
      )
    ]

  teamLinks: (team) ->
    return [] unless team
    base = team.url()
    [
      @link(base, I18n.t("dashboard.title"), "home")
      @link("#{base}/members", I18n.t("members.title"), "people")
      @link("#{base}/calendar", I18n.t("calendar.title"), "date_range")
    ]

  link: (route, title, icon, options = {}) ->
    m("li", { class: if m.route() == route then "current" else "" }
      m("a", $.extend({ href: route, config: m.route }, options),
        m("i", { class: "material-icons" }, icon),
        m("span", title)
      )
    )

  teamLink: (team) ->
    @link(
      team.url(), team.name(), "people"
      onclick: @switchTeams
      "data-team-id": team.toParam()
    )

  logoutLink: ->
    @link(
      "/users/sign_out",
      I18n.t("devise.sessions.sign_out"),
      "exit_to_app",
      { config: null, "data-method": "delete" }
    )

  toggleTeams: (e) =>
    e.preventDefault()
    e.stopPropagation()
    @showTeams(!@showTeams())
    App.Models.Team.fetch().then(@teams) if @showTeams()

  switchTeams: (e) =>
    id = $(e.target).closest("[data-team-id]").data("team-id")
    App.Models.Team.fetch(id).then(@team) if id

  hideTeams: (e) =>
    e.preventDefault()
    @showTeams(false)
    m.route($(e.target).closest("a").attr("href"))

App.Components.Sidebar =
  controller: ->
    new Sidebar(App.Components.Sidebar.properties)

  view: (controller) ->
    controller.view()
