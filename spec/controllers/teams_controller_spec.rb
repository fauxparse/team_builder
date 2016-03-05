require 'rails_helper'

RSpec.describe TeamsController, type: :controller do
  let(:member) { FactoryGirl.create(:member) }
  let(:logged_in_user) { member.user }
  let(:team) { member.team }

  before { team }

  login

  describe 'GET index' do
    context 'as HTML' do
      before { get :index }

      it 'succeeds' do
        expect(response).to be_success
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
end
