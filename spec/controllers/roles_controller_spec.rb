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
              "plural" => "participants",
              "default_plural" => "participants"
            }
          ]
        end

        it { is_expected.to eq json }
      end
    end
  end

  describe 'POST /teams/:team_id/roles' do
    before { post :create, params: params }
    let(:params) { { team_id: team.to_param, role: attrs } }
    let(:attrs) { { name: "actor", plural: "actors" } }

    describe '#response' do
      subject { response }
      it { is_expected.to be_success }

      describe '#body' do
        subject { ActiveSupport::JSON.decode(response.body) }
        let(:json) do
          {
            "id" => Role.last.id,
            "name" => "actor",
            "plural" => "actors",
            "default_plural" => "actors"
          }
        end

        it { is_expected.to eq json }
      end
    end
  end

  describe 'PUT /teams/:team_id/roles/:id' do
    before { role }
    let(:request) { put :update, params: params }
    let(:params) { { team_id: team.to_param, id: role.id, role: attrs } }
    let(:attrs) { { name: "muso", plural: "musos" } }

    it 'does not create a new role' do
      expect(Role.count).to eq 1
      expect { request }.not_to change { Role.count }
    end

    describe '#response' do
      before { request }
      subject { response }
      it { is_expected.to be_success }

      describe '#body' do
        subject { ActiveSupport::JSON.decode(response.body) }
        let(:json) do
          {
            "id" => role.id,
            "name" => "muso",
            "plural" => "musos",
            "default_plural" => "musos"
          }
        end

        it { is_expected.to eq json }
      end
    end
  end

  describe 'POST /teams/:team_id/roles/check' do
    before { role }
    let(:request) { post :check, params: params }
    let(:params) { { team_id: team.to_param, role: attrs } }
    let(:attrs) { { name: "muso" } }

    it 'does not save a role' do
      expect_any_instance_of(Role).not_to receive(:save)
    end

    describe '#response' do
      before { request }
      subject { response }
      it { is_expected.to be_success }

      describe '#body' do
        subject { ActiveSupport::JSON.decode(response.body) }
        let(:json) do
          {
            "id" => nil,
            "name" => "muso",
            "plural" => "musos",
            "default_plural" => "musos"
          }
        end

        it { is_expected.to eq json }
      end
    end
  end

  describe 'POST /teams/:team_id/roles/:id/check' do
    before { role }
    let(:request) { post :check, params: params }
    let(:params) { { team_id: team.to_param, id: role.id, role: attrs } }
    let(:attrs) { { name: "muso" } }

    it 'does not save a role' do
      expect_any_instance_of(Role).not_to receive(:save)
    end

    describe '#response' do
      before { request }
      subject { response }
      it { is_expected.to be_success }

      describe '#body' do
        subject { ActiveSupport::JSON.decode(response.body) }
        let(:json) do
          {
            "id" => role.id,
            "name" => "muso",
            "plural" => "musos",
            "default_plural" => "musos"
          }
        end

        it { is_expected.to eq json }
      end
    end
  end
end
