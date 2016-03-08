m.route.mode = "pathname"
m.route $("main")[0], "/",
  "/teams/:team": App.Components.ToDo
  "/teams": App.Components.ToDo
  "/calendar/:year/:month": App.Components.Calendar
  "/calendar/:year": App.Components.Calendar
  "/calendar": App.Components.Calendar
  "/": App.Components.Dashboard
