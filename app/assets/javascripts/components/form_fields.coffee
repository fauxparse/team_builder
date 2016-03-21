class TextField
  constructor: (label, prop, options) ->
    @label = label
    @value = prop
    @options = options
    @options.errors ||= -> []
    @options.type ||= "text"
    @options.id ||= @options.name.replace(/\[/g, "_").replace(/\]/g, "")

  view: ->
    m("div", { class: @fieldClass() },
      @inputTag(),
      m("label", { for: @options.id }, @label) if @label,
      @errorMessages()
    )

  fieldClass: ->
    klass = "field"
    klass += " with-floating-label" if @label
    klass += " has-value" if @value()
    klass += " has-errors" if @options.errors().length
    klass

  inputTag: ->
    options = $.extend({ oninput: @onInput }, @options)
    delete options.errors
    if options.type == "textarea"
      delete options.type
      m("textarea", options, @value() || "")
    else
      m("input", $.extend({ type: @type, value: @value() || "" }, options))

  errorMessages: ->
    (m("p", { class: "error" }, message) for message in @options.errors())

  onInput: (e) =>
    m.computation => @value(e.target.value)

class URLField extends TextField
  constructor: (label, prop, options) ->
    @root = options.root
    delete options.root
    super(label, prop, options)

  fieldClass: ->
    super().replace(" with-floating-label", "") + " url-field"

  view: ->
    m("div", { class: @fieldClass() },
      m("label", { for: @options.id }, @label) if @label,
      m("div", { class: "input-group" },
        m("label", { for: @options.id }, @root),
        @inputTag(),
        m("hr")
      ),
      @errorMessages()
    )

App.Components.TextField =
  controller: (args...) ->
    new TextField(args...)

  view: (controller) ->
    controller.view()

App.Components.URLField =
  controller: (args...) ->
    new URLField(args...)

  view: (controller) ->
    controller.view()
