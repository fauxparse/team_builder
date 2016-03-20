class App.Models.Member extends App.Model
  @configure "Member", "name", "email"

  @url: -> "/teams/#{m.route.param("team")}/members"
