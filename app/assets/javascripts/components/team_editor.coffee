class TeamEditor extends App.Components.Section
  constructor: (props) ->
    @team = props.team
    @autoUpdateSlug = !@team().id()

  view: ->
    @team().form({ class: "team-editor" },
      m("div", { class: "field" },
        m.component(App.Components.TextField,
          "Team name",
          @team().name,
          name: "team[name]",
          oninput: @nameChanged,
          errors: @team().errorsOn("name")
        )
      ),
      m("div", { class: "field" },
        m("div", { class: "url-field" },
          m("label", { for: "team_slug" }, @teamsURL())
          m("input",
            id: "team_slug"
            name: "team[slug]"
            value: @team().slug() || ""
            oninput: @slugChanged
          )
        ),
        @errorMessagesFor("slug")
      )
    )

  errorMessagesFor: (attr) ->
    messages = @team().errorsOn(attr)
    (m("p", { class: "error" }, message) for message in messages)

  teamsURL: ->
    "#{location.protocol}//#{location.host}#{App.Models.Team.url()}/"

  nameChanged: (e) =>
    @team().name(e.target.value)
    @check()

  slugChanged: (e) =>
    @team().slug(e.target.value)
    @autoUpdateSlug = false
    @check()

  check: ->
    @checking ||= m.prop()
    @checking()?.abort()
    clearTimeout(@_timeout)
    @_timeout = setTimeout(@doCheck, 250)

  doCheck: =>
    data = @team().asJSON()
    delete data.slug if @autoUpdateSlug

    @_check = m.request(
      url: "/teams/check"
      method: "POST"
      config: @checking
      data: data
    ).then(@processCheckResponse)

  processCheckResponse: (data) =>
    @team().attributes(data)

App.Components.TeamEditor =
  controller: (args...) ->
    new TeamEditor(args...)

  view: (controller) ->
    controller.view()
