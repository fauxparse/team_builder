class Sidebar
  constructor: (props = {}) ->
    @member = m.prop(new App.Models.Member(props.member))
    @team = m.prop(new App.Models.Team(props.team))
    $("#show-sidebar").on "change", (e) =>
      @opened() if e.target.checked

  opened: ->
    unless @_opened
      @_opened = true

  view: ->
    [
      m("section", { class: "profile" },
        m("div", { class: "name" }, @member().name()),
        m("div", { class: "team" }, @team().name()) if @team()
      ),
      m("section",
        m("ul",
          @link("/", "Dashboard", "dashboard"),
          @link("/calendar", "Calendar", "event"),
          @link("/users/sign_out", "Log out", "exit_to_app", { config: null, "data-method": "delete" })
        )
      )
    ]

  link: (route, title, icon, options = {}) ->
    m("li", { class: if m.route() == route then "current" else "" }
      m("a", $.extend({}, { href: route, config: m.route }, options),
        m("i", { class: "material-icons" }, icon),
        m("span", title)
      )
    )

App.Components.Sidebar =
  controller: ->
    new Sidebar(App.Components.Sidebar.properties)

  view: (controller) ->
    controller.view()
