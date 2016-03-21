class TeamMember extends App.Components.Section
  constructor: (props) ->
    @member = m.prop()
    App.Models.Member.fetch(m.route.param("id")).then(@member)

  view: ->
    klass = "team-member"
    m("div", { class: klass },
      m.component(App.Components.Header, title: => @member()?.name()),
      m("div", { class: "team-members-inner" }
      )
    )

App.Components.TeamMember =
  controller: (args...) ->
    new TeamMember(args...)

  view: (controller) ->
    controller.view()
