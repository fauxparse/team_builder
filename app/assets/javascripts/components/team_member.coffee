class TeamMember extends App.Components.Section
  constructor: (props) ->
    @member = m.prop()
    App.Models.Member.fetch(m.route.param("id")).then(@member)

  view: ->
    klass = "team-member"
    m("section", { class: klass },
      m.component(App.Components.Header,
        title: => @member()?.name()
        content: ->
          m("div", { class: "header-image" },
            m("img", src: "/assets/placeholder/profile-header.jpg")
            m("div", { class: "scrim" })
          )
      )
      m("div",
        { class: "team-member-inner", config: @setupScrolling.bind(this) },
        m("ul", { class: "team-member-details" }
          m("li", { rel: "name" },
            m("i", { class: "material-icons" }, "assignment_ind")
            m.component(App.Components.TextField,
              I18n.t("activerecord.attributes.member.display_name")
              @member().name
              name: "member[name]"
              readonly: true
              errors: => @member().errorsOn("name")
            )
          )
          m("li", { rel: "email" },
            m("i", { class: "material-icons" }, "email")
            m.component(App.Components.TextField,
              I18n.t("activerecord.attributes.member.email")
              @member().email
              name: "member[email]"
              type: "email"
              readonly: true
              errors: => @member().errorsOn("email")
            )
          )
        ) if @member()?
      )
    )

  setupScrolling: (el) =>
    @scrollable = el
    @header = $(el).prev("header")
    @headerHeight = @header.outerHeight()
    @minHeaderHeight = parseInt(@header.css("minHeight"), 10)
    el.addEventListener("scroll", @onscroll.bind(this), true)

  onscroll: (e) =>
    if e.target == @scrollable
      opacity = Math.min(
        e.target.scrollTop / (@headerHeight - @minHeaderHeight),
        1
      )
      @header
        .css("max-height", @headerHeight - e.target.scrollTop)
        .find(".scrim").css("opacity", opacity)

App.Components.TeamMember =
  controller: (args...) ->
    new TeamMember(args...)

  view: (controller) ->
    controller.view()
