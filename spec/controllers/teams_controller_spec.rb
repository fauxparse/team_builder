require 'rails_helper'

RSpec.describe TeamsController, type: :controller do
  let(:member) { FactoryGirl.create(:member) }
  let(:logged_in_user) { member.user }
  let(:team) { member.team }

  before { team }

  login

  describe 'GET /teams' do
    context 'as HTML' do
      before { get :index }

      it 'redirects to the team page' do
        expect(response).to redirect_to("/teams/#{team.to_param}")
      end
    end

    context 'as JSON' do
      before { get :index, format: :json }

      let(:expected_response) do
        [{ "id" => team.id, "name" => team.name, "slug" => team.slug }]
      end

      it 'succeeds' do
        expect(response).to be_success
        expect(response.content_type).to eq("application/json")
      end

      it 'returns JSON' do
        expect(ActiveSupport::JSON.decode(response.body))
          .to eq expected_response
      end
    end
  end

  describe 'GET /teams/:id' do
    context 'as HTML' do
      before { get :show, params: { id: team.to_param } }

      it 'assigns the team' do
        expect(assigns(:team)).to eq team
      end

      it 'sets the current team' do
        expect(cookies[:team_id]).to eq member.team_id.to_s
      end
    end
  end

  describe 'GET /teams/new' do
    context 'as HTML' do
      before { get :new }

      it 'assigns a new team' do
        expect(assigns(:team)).to be_an_instance_of(Team)
      end
    end
  end
end
