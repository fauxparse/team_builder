m.route.mode = "pathname"
m.route $("main")[0], "/",
  "/teams/:team": App.Components.Calendar
  "/teams": App.Components.Calendar
  "/calendar": App.Components.Calendar
  "/": App.Components.Dashboard
