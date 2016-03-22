class InviteTeamMembers extends App.Components.Section
  constructor: (props) ->
    @emails = m.prop("")
    @saving = m.prop(false)
    @members = m.prop([])

  view: ->
    klass = "invite-team-members"
    klass += " saving" if @saving()
    m("section", { class: klass },
      m.component(App.Components.Header, title: -> I18n.t("teams.invite.title")),
      m("div", { class: "new-team-inner" },
        @formOrResults(),
      )
    )

  formOrResults: ->
    if @members().length
      [
        m("p", @statusMessage())
        m("ul", { class: "invited members" },
          (@renderMember(member) for member in @members())
        )
      ]
    else
      [
        m.component(App.Components.TextField,
          I18n.t("teams.invite.emails")
          @emails
          type: "textarea"
          name: "emails"
          config: autosize
          errors: => []
        )
        m("p", { class: "explanation" }, I18n.t("teams.invite.explanation"))
        m("div",
          @saveButton()
        )
      ]

  statusMessage: ->
    succeeded = []
    failed = []
    for member in @members()
      (if member.hasErrors() then failed else succeeded).push member
    status = if succeeded.length
      if failed.length then "mixed" else "success"
    else if failed.length
      "failure"
    else
      "nothing"
    I18n.t("teams.invite.status.#{status}", succeeded: succeeded.length, failed: failed.length)

  renderMember: (member) ->
    success = !member.hasErrors()
    klass = "#{if success then "successful" else "failed"} member"
    m("li", { class: klass, "data-name": member.name(), "data-email": member.email() },
      m("i", class: "material-icons")
      m("span",
        m("span", { class: "name" }, member.name())
        m("span", { class: "email" }, member.email())
        (m("span", { class: "error" }, error) for error in member.allErrors())
      )
    )

  saveButton: ->
    if @saving()
      m("button", { disabled: true }, I18n.t("common.saving"))
    else
      m("button", { onclick: @inviteClicked }, I18n.t("teams.invite.save"))

  inviteClicked: (e) =>
    m.computation =>
      @saving(true)
    setTimeout =>
      @saving(
        m.request
          url: "/teams/#{m.route.param("team")}/members"
          method: "POST"
          data:
            members: @emails()
        .then(@saved, @saved)
      )
    , 150

  saved: (data) =>
    @saving(false)
    @members(new App.Models.Member(attrs) for attrs in data)

App.Components.InviteTeamMembers =
  controller: (args...) ->
    new InviteTeamMembers(args...)

  view: (controller) ->
    controller.view()
