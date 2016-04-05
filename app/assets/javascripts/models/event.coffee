class App.Models.Event extends App.Model
  @configure "Event", "name", "slug", "occurrence", "starts_at", "stops_at"

  constructor: (attrs) ->
    @dateTimeAttributes "starts_at", "stops_at"
    super(attrs)

  toParam: ->
    @slug()

  occurrence: (value) ->
    @_occurrence ||= m.prop()
    @_occurrence(new App.Models.Occurrence(value)) if value?
    @_occurrence()

  @url: -> "/teams/#{m.route.param("team")}/events"

  @blank: ->
    new App.Models.Event(
      starts_at: moment().startOf("hour").add(1, "hour"),
      duration: 3600
    )
