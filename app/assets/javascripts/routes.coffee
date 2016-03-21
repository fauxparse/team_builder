m.route.mode = "pathname"
m.route document.querySelector("main"), "/",
  "/teams/:team/members/new": App.Components.InviteTeamMembers
  "/teams/:team/members": App.Components.TeamMembers
  "/teams/:team/roles": App.Components.TeamRoles
  "/teams/new": App.Components.NewTeam
  "/teams/:team": App.Components.ToDo
  "/teams": App.Components.ToDo
  "/calendar/:year/:month": App.Components.Calendar
  "/calendar/:year": App.Components.Calendar
  "/calendar": App.Components.Calendar
  "/": App.Components.Dashboard
