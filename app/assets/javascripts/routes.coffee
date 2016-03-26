m.route.mode = "pathname"
m.route document.querySelector("main"), "/",
  "/teams/:team/events/:id/:year/:month/:day": App.Components.ManageEvent
  "/teams/:team/members/new": App.Components.InviteTeamMembers
  "/teams/:team/members/:id": App.Components.TeamMember
  "/teams/:team/members": App.Components.TeamMembers
  "/teams/:team/roles": App.Components.TeamRoles
  "/teams/:team/calendar": App.Components.Calendar
  "/teams/new": App.Components.NewTeam
  "/teams/:team": App.Components.ToDo
  "/teams": App.Components.ToDo
  "/calendar/:year/:month": App.Components.Calendar
  "/calendar/:year": App.Components.Calendar
  "/calendar": App.Components.Calendar
  "/": App.Components.Dashboard
