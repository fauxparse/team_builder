class TextField
  constructor: (label, prop, options) ->
    @label = label
    @value = prop
    @options = options
    @options.errors ||= []
    @options.type ||= "text"
    @options.id ||= @options.name.replace(/\[/g, "_").replace(/\]/g, "")

  view: ->
    m("div", { class: "field" },
      m("label", { for: @options.id }, @label),
      @inputTag(),
      @errorMessages()
    )

  inputTag: ->
    options = $.extend({ oninput: @onInput }, @options)
    delete options.errors
    if @type == "textarea"
      delete options.type
      m("textarea", options, @value() || "")
    else
      m("input", $.extend({ type: @type, value: @value() || "" }, options))

  errorMessages: ->
    (m("p", { class: "error" }, message) for message in @options.errors)

  onInput: (e) =>
    m.computation => @value(e.target.value)

App.Components.TextField =
  controller: (args...) ->
    new TextField(args...)

  view: (controller) ->
    controller.view()
