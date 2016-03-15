class App.Models.Team extends App.Model
  @configure "Team", "name", "slug"

  toParam: -> @slug()

  @url: -> "/teams"
