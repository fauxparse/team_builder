class App.Models.Team extends App.Model
  @configure "Team", "name", "slug"

  toParam: -> @slug()

  @url: -> "/teams"

  @current: ->
    @current ||= new this(App.Components.Sidebar.properties.team)
