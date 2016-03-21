require 'rails_helper'

RSpec.describe RolesController, type: :controller do
  let(:member) { FactoryGirl.create(:member, team: team) }
  let(:logged_in_user) { member.user }
  let(:team) { role.team }
  let(:role) { FactoryGirl.create(:role) }

  login

  describe 'GET /teams/:team_id/roles' do
    context 'as HTML' do
      subject { response }

      before { get :index, params: { team_id: team.to_param } }

      it { is_expected.to be_success }
    end

    context 'as JSON' do
      subject { response }

      before { get :index, params: { team_id: team.to_param, format: :json } }

      it { is_expected.to be_success }

      describe 'response body' do
        subject { ActiveSupport::JSON.decode(response.body) }

        let(:json) do
          [
            {
              "id" => role.id,
              "name" => "participant",
              "plural" => "participants"
            }
          ]
        end

        it { is_expected.to eq json }
      end
    end
  end
end
