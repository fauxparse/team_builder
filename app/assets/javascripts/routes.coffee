m.route.mode = "pathname"
m.route $("main")[0], "/",
  "/teams": App.Components.Calendar
  "/calendar": App.Components.Calendar
  "/": App.Components.Dashboard
