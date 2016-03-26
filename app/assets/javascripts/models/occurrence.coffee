class App.Models.Occurrence extends App.Model
  @configure "Occurrence", "team", "event", "starts_at", "previous", "next"

  constructor: (attrs) ->
    @dateTimeAttribute "starts_at"
    @dateTimeAttribute "previous"
    @dateTimeAttribute "next"
    super(attrs)

  url: ->
    "/teams/#{@team()}/events/#{@event()}/#{@starts_at.format("YYYY/MM/DD")}"
