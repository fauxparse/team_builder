require 'rails_helper'

describe SidebarHelper do
  describe '#sidebar' do
    let(:member) { FactoryGirl.create(:member) }
    let(:team) { member.team }
    let(:html_options) do
      {
        class: "sidebar",
        data: {
          mithril_class: "App.Components.Sidebar",
          mithril_props: ActiveSupport::JSON.encode(
            member: {
              id: member.id,
              name: member.display_name,
              admin: false
            },
            team: {
              id: team.id,
              name: team.name,
              slug: team.slug
            }
          )
        }
      }
    end

    before do
      helper.instance_variable_set :@current_member, member
      helper.instance_variable_set :@current_team, team

      class << helper
        attr_reader :current_member, :current_team
      end
    end

    it 'renders an aside tag' do
      expect(helper)
        .to receive(:content_tag)
        .with("aside", "", html_options)
      helper.sidebar
    end
  end
end
