class Tabs
  constructor: (props) ->
    @selected = props.selected
    @tabs = props.tabs

  config: (el, isInitialized) =>
    unless isInitialized
      $(window).on "resize", @resize

  onunload: =>
    $(window).off "resize", @resize

  view: ->
    m("div", { class: "tabs", config: @config },
      m("ul",
        (@renderTab(tab...) for tab in @tabs)
      )
      m("hr", { config: @positionHighlight })
    )

  renderTab: (name, label) ->
    klass = if @selected() == name then "selected" else ""
    m("li", { class: klass, "data-tab": name, onclick: @click },
      m("span", label || name)
    )

  resize: =>
    @positionHighlight()

  positionHighlight: (el, isInitialized) =>
    @_highlight = el || @_highlight
    if @_highlight
      highlight = $(@_highlight)
      selected = highlight.prev().find(".selected")
      if selected.length
        x1 = highlight.position().left
        w1 = highlight.outerWidth()
        x2 = selected.position().left
        w2 = selected.outerWidth()
        if x2 + w2 > x1 + w1
          highlight.css(width: (x2 + w2) - x1)
        else
          highlight.css(left: x2, width: x1 + w1 - x2)
        setTimeout ->
          highlight.css(left: x2, width: w2)
        , 250
      else
        highlight.css(left: 0, width: 0)

  click: (e) =>
    @selected($(e.target).closest("li").data("tab"))

App.Components.Tabs =
  controller: (args...) ->
    new Tabs(args...)

  view: (controller) ->
    controller.view()
