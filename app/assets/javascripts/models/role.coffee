class App.Models.Role extends App.Model
  @configure "Role", "name", "plural"

  constructor: (attrs) ->
    super(attrs)
    plural = @plural
    @plural = (value) =>
      plural(value) if arguments.length
      plural() || @default_plural()

  default_plural: (value) ->
    @_defaultPlural = value if arguments.length
    @_defaultPlural || I18n.t("activerecord.defaults.role.plural")

  @url: -> "/teams/#{m.route.param("team")}/roles"

  asJSON: ->
    json = super
    delete json.default_plural
    json
