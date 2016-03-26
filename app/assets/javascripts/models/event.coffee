class App.Models.Event extends App.Model
  @configure "Event", "name", "slug", "occurrence"

  occurrence: (value) ->
    @_occurrence ||= m.prop()
    @_occurrence(new App.Models.Occurrence(value)) if value?
    @_occurrence()

  @url: -> "/teams/#{m.route.param("team")}/events"
