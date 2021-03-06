require 'rails_helper'

RSpec.describe MembersController do
  let(:member) { FactoryGirl.create(:member) }
  let(:logged_in_user) { member.user }
  let(:team) { member.team }

  login

  before do
    allow_any_instance_of(Avatar)
      .to receive(:url)
      .and_return("https://placeimg.com/200/200/animals")
  end

  describe 'GET /teams/:team_id/members' do
    context 'as HTML' do
      subject { response }

      before { get :index, params: { team_id: team.slug } }

      it { is_expected.to be_success }
    end

    context 'as JSON' do
      subject { response }
      let(:json) { ActiveSupport::JSON.decode(response.body) }

      before { get :index, params: { team_id: team.slug, format: :json } }

      it { is_expected.to be_success }

      it 'returns the team members as JSON' do
        expect(json).to eq [
          {
            "id" => member.id,
            "name" => member.display_name,
            "email" => member.email,
            "admin" => false,
            "avatar" => "https://placeimg.com/200/200/animals"
          }
        ]
      end
    end
  end

  describe 'GET /teams/:team_id/members/:id' do
    context 'as HTML' do
      subject { response }

      before { get :show, params: { team_id: team.slug, id: member.id } }

      it { is_expected.to be_success }
    end

    context 'as JSON' do
      subject { response }
      let(:json) { ActiveSupport::JSON.decode(response.body) }

      before do
        get :show, params: {
          team_id: team.slug,
          id: member.id,
          format: :json
        }
      end

      it { is_expected.to be_success }

      it 'returns the team member as JSON' do
        expect(json).to eq({
          "id" => member.id,
          "name" => member.display_name,
          "email" => member.email,
          "admin" => false,
          "avatar" => "https://placeimg.com/200/200/animals"
        })
      end
    end
  end

  describe 'GET /teams/:team_id/members/new' do
    context 'as HTML' do
      subject { response }

      before { get :new, params: { team_id: team.slug } }

      it { is_expected.to be_success }
    end
  end

  describe 'POST /teams/:team_id/members' do
    let(:params) { { format: :json, members: data, team_id: team.slug } }
    let(:perform_request) { post :create, params: params }
    let(:json) { ActiveSupport::JSON.decode(response.body) }

    context 'with good data' do
      let(:data) do
        <<~EOS
          "Chewie" <chewie@resistance.org>
        EOS
      end

      it 'creates the members' do
        expect { perform_request }
          .to change { team.members.count }.by(1)
      end

      it 'returns the new members as JSON' do
        perform_request
        expect(json).to eq [
          {
            "id" => Member.last.id,
            "name" => "Chewie",
            "email" => "chewie@resistance.org",
            "admin" => false,
            "avatar" => "https://placeimg.com/200/200/animals"
          }
        ]
      end
    end

    context 'with bad data' do
      let(:data) do
        <<~EOS
          Chewie
        EOS
      end

      it 'does not create the members' do
        expect { perform_request }
          .not_to change { team.members.count }
      end

      it 'returns the new members as JSON' do
        perform_request
        expect(json).to eq [
          {
            "id" => nil,
            "name" => "Chewie",
            "email" => "chewie",
            "admin" => false,
            "avatar" => "https://placeimg.com/200/200/animals",
            "errors" => {
              "email" => [
                "Email is invalid"
              ]
            }
          }
        ]
      end
    end
  end
end
