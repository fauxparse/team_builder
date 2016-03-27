class App.Models.Occurrence extends App.Model
  @configure "Occurrence", "team", "event", "starts_at", "previous", "next"

  constructor: (attrs) ->
    @dateTimeAttributes "starts_at", "previous", "next"
    super(attrs)

  toParam: ->
    @event() + @starts_at().format("/YYYY/MM/DD")

  url: ->
    "/teams/#{@team()}/events/#{@toParam()}"

  buildNext: ->
    return unless @next()
    new App.Models.Occurrence({
      team: @team(), event: @event(),
      starts_at: @next(), previous: @starts_at()
    })

  buildPrevious: ->
    return unless @previous()
    new App.Models.Occurrence({
      team: @team(), event: @event(),
      starts_at: @previous(), next: @starts_at()
    })
