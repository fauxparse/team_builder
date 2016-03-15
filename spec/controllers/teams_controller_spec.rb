require 'rails_helper'

RSpec.describe TeamsController, type: :controller do
  let(:member) { FactoryGirl.create(:member) }
  let(:logged_in_user) { member.user }
  let(:team) { member.team }
  let(:json) { ActiveSupport::JSON.decode(response.body) }

  login

  describe 'GET /teams' do
    before { team }

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
        expect(json).to eq expected_response
      end
    end
  end

  describe 'GET /teams/:id' do
    before { team }

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
  :w
    end
  end

  describe 'POST /teams/create' do
    context 'as JSON' do
      let(:request) { post :create, params: { team: attrs, format: :json } }

      context 'when the attributes are valid' do
        let(:attrs) { FactoryGirl.attributes_for(:team) }

        it 'is successful' do
          request
          expect(response).to be_success
        end

        it 'returns the attributes' do
          request
          expect(json).to eq({
            "id" => Team.last.id,
            "name" => "JediStormPilot",
            "slug" => "jedistormpilot-1"
          })
        end

        it 'creates a team' do
          expect { request }.to change { Team.count }.by(1)
        end
      end

      context 'when the attributes are invalid' do
        let(:attrs) { { name: "" } }

        it 'is unsuccessful' do
          request
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns the attributes with errors' do
          request
          expect(json).to eq({
            "id" => nil,
            "name" => "",
            "slug" => "",
            "errors" => [
              "Name can't be blank",
              "Slug can't be blank"
            ]
          })
        end

        it 'does not create a team' do
          expect { request }.not_to change { Team.count }
        end
      end
    end
  end

  describe 'POST /teams/check' do
    context 'as JSON' do
      before { post :check, params: { team: attrs, format: :json } }

      context 'when the attributes are valid' do
        let(:attrs) { FactoryGirl.attributes_for(:team) }

        it 'is successful' do
          expect(response).to be_success
        end

        it 'returns the attributes' do
          expect(json).to eq({
            "id" => nil,
            "name" => "JediStormPilot",
            "slug" => "jedistormpilot-1"
          })
        end
      end

      context 'when the attributes are invalid' do
        let(:attrs) { { name: "" } }

        it 'is unsuccessful' do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns the attributes with errors' do
          expect(json).to eq({
            "id" => nil,
            "name" => "",
            "slug" => "",
            "errors" => [
              "Name can't be blank",
              "Slug can't be blank"
            ]
          })
        end
      end
    end
  end
end
