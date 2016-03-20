m.route.mode = "pathname"
m.route $("main")[0], "/",
  "/teams/:team/members/new": App.Components.InviteTeamMembers
  "/teams/new": App.Components.NewTeam
  "/teams/:team": App.Components.ToDo
  "/teams": App.Components.ToDo
  "/calendar/:year/:month": App.Components.Calendar
  "/calendar/:year": App.Components.Calendar
  "/calendar": App.Components.Calendar
  "/": App.Components.Dashboard
