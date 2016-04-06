require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  let(:member) { FactoryGirl.create(:member) }
  let(:logged_in_user) { member.user }
  let(:team) { member.team }
  let(:event) { FactoryGirl.create(:event, :weekly, team: team) }
  let(:base_params) do
    { team_id: team.to_param, format: format }
  end
  let(:json) { ActiveSupport::JSON.decode(response.body) }

  login

  describe 'GET #show' do
    subject { response }

    let(:params) { base_params.merge(id: event.to_param) }

    before { get :show, params: params }

    context 'as HTML' do
      let(:format) { :html }

      it { is_expected.to be_success }
    end

    context 'as JSON' do
      let(:format) { :json }

      it { is_expected.to be_success }

      describe '#body' do
        subject { json }
        let(:params) { base_params.merge(id: event).merge(date) }
        let(:date) { {} }

        it { is_expected.to include "occurrence" }

        context 'for a particular date' do
          let(:date) { { year: 2015, month: 12, day: 24 } }

          it 'includes the correct occurrence' do
            expect(event.time_zone.parse(json["occurrence"]["starts_at"]))
              .to eq event.starts_at + 1.week
          end
        end

        context 'for a bad date' do
          let(:date) { { year: 2015, month: 12, day: 18 } }

          it 'fails' do
            expect(response).to have_http_status(:not_found)
          end
        end
      end
    end
  end

  describe 'GET #new' do
    subject { response }
    let(:request) { get :new, params: params }
    let(:params) { { team_id: team.to_param, format: format } }

    context 'as HTML' do
      let(:format) { :html }

      before { request }

      it { is_expected.to be_success }
    end

    context 'as JSON' do
      let(:format) { :json }

      before { request }

      it { is_expected.to be_success }

      describe '#body' do
        subject { json }

        it { is_expected.to be_a Hash }
      end
    end
  end

  describe 'post #check' do
    subject { response }

    let(:request) { post :check, params: params }
    let(:params) { base_params.merge(event: event_params) }
    let(:event_params) { FactoryGirl.attributes_for(:event) }
    let(:format) { :json }

    before { request }

    context 'with a valid event' do
      it { is_expected.to be_success }

      it 'fills in the slug' do
        expect(json["slug"]).to eq "an-awakening"
      end
    end

    context 'with a blank name' do
      let(:event_params) do
        FactoryGirl.attributes_for(:event).merge(name: "")
      end

      it { is_expected.to have_http_status(:unprocessable_entity) }

      it 'has an error on the name field' do
        expect(json["errors"]["name"])
          .to eq ["Event name can’t be blank"]
      end
    end
  end
end
