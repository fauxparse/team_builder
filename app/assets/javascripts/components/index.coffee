#= require_self
#= require_tree .

App.Components = {}

class App.Components.Section
  backButton: (path) ->
    ->
      m("a", { class: "button", href: path, config: m.route.animate() },
        m("i", { class: "material-icons" }, "arrow_back")
      )

  onunload: ->
    document.getElementById("show-sidebar").checked = false
