class App.Models.Occurrence extends App.Model
  @configure "Occurrence", "team", "event", "starts_at", "stops_at",
    "previous", "next", "availability"

  constructor: (attrs) ->
    @dateTimeAttributes "starts_at", "stops_at", "previous", "next"
    super(attrs)

  toParam: ->
    @event() + @starts_at().format("/YYYY/MM/DD")

  url: ->
    "/teams/#{@team()}/events/#{@toParam()}"

  buildNext: ->
    return unless @next()
    new App.Models.Occurrence({
      team: @team(),
      event: @event(),
      starts_at: @next(),
      stops_at: @next().clone().add(@duration(), "seconds"),
      previous: @starts_at()
    })

  buildPrevious: ->
    return unless @previous()
    new App.Models.Occurrence({
      team: @team(),
      event: @event(),
      starts_at: @previous(),
      stops_at: @previous().clone().add(@duration(), "seconds"),
      next: @starts_at()
    })

  duration: (value) ->
    @stops_at().diff(@starts_at(), "seconds")

  availabilityFor: (member) ->
    (@availability() || {})[member.id()]

  setAvailabilityFor: (member, availability) ->
    hash = @availability() || {}
    hash[member.id()] = availability
    @availability(hash)
    clearTimeout(@_updateAvailability)
    @_updateAvailability = setTimeout(@updateAvailability, 250)

  updateAvailability: =>
    m.request({
      method: "put"
      url: @url() + "/availability"
      data: { availability: @availability() || {} }
    }).then(@availability)
