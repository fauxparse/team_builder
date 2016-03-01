module SidebarHelper
  def sidebar
    mithril_component(
      "App.Components.Sidebar", {
        member: serialize(current_member),
        team:   serialize(current_team)
      }, tag: "aside", class: "sidebar"
    )
  end
end
