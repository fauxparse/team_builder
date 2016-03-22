class TeamMembers extends App.Components.Section
  constructor: (props) ->
    @members = m.prop([])
    App.Models.Member.fetch().then(@members)

  view: ->
    klass = "team-members"
    m("section", { class: klass },
      m.component(App.Components.Header, title: -> I18n.t("members.title")),
      m("div", { class: "team-members-inner" }
        m("ul", { class: "members" },
          (@member(member) for member in @members())
        )
      )
    )

  member: (member) ->
    m("li", { class: "member" },
      m("a", { href: member.url(), config: m.route },
        m("i", { class: "avatar" }, member.name().substr(0, 1)),
        m("span", { class: "name" }, member.name())
      )
    )

App.Components.TeamMembers =
  controller: (args...) ->
    new TeamMembers(args...)

  view: (controller) ->
    controller.view()
