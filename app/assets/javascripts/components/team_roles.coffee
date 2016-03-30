class TeamRoles extends App.Components.Section
  constructor: (props) ->
    @roles = m.prop([])
    App.Models.Role.fetch().then(@roles)

  view: ->
    klass = "team-roles"
    m("section", { class: klass },
      m.component(App.Components.Header, title: -> I18n.t("roles.title")),
      m("div", { class: "team-roles-inner" },
        m("ul", { class: "roles" },
          (m.component(RoleEditor.component, role: role) for role in @roles())
        )
        m("button", { onclick: @add }, I18n.t("roles.add"))
      )
    )

  add: =>
    m.computation =>
      @roles().push(new App.Models.Role)

class RoleEditor
  constructor: (props) ->
    @role = props.role

  view: ->
    klass = "role"
    m("li", { class: klass },
      m("i", { class: "material-icons" }, "account_circle")
      m.component(App.Components.TextField,
        ""
        @role.name
        name: "name"
        errors: => @role.errorsOn("name")
        placeholder: I18n.t("activerecord.defaults.role.name")
        oninput: @nameChanged
      )
      m.component(App.Components.TextField,
        ""
        @role.plural
        name: "plural"
        errors: => @role.errorsOn("plural")
        placeholder: @role.plural()
        oninput: @pluralChanged
      )
      m("button", { class: "material-icons", rel: "save", onclick: @save })
    )

  save: =>
    @role.save()

  cancel: ->

  destroy: ->

  nameChanged: (e) =>
    @role.name(e.target.value)
    @check()

  pluralChanged: (e) =>
    @role.plural(e.target.value)
    @check()

  check: ->
    @checking ||= m.prop()
    @checking()?.abort()
    clearTimeout(@_timeout)
    @_timeout = setTimeout(@doCheck, 250)

  doCheck: =>
    data = @role.asJSON()
    data.plural = "" if @role.plural() == @role.default_plural()

    @_check = m.request(
      url: @role.url() + "/check"
      method: "POST"
      config: @checking
      data: data
    ).then(@processCheckResponse)

  processCheckResponse: (data) =>
    @role.attributes(data)

  @component:
    controller: (args...) -> new RoleEditor(args...)
    view: (controller) -> controller.view()

App.Components.TeamRoles =
  controller: (args...) ->
    new TeamRoles(args...)

  view: (controller) ->
    controller.view()
