class Header
  constructor: (props = {}) ->
    @title = props.title
    @left = props.left ? @left
    @right = props.right ? @right

  view: ->
    m("header",
      @left(),
      m("h2", @title())
      @right()
    )

  toggle: =>
    @open(!@open())

  left: ->
    m("label", { for: "show-sidebar", class: "material-icons button" }, "menu")

  right: -> []

App.Components.Header =
  controller: (props) ->
    new Header(props)

  view: (controller) ->
    controller.view()