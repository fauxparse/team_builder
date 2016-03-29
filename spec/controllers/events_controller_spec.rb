require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  let(:member) { FactoryGirl.create(:member) }
  let(:logged_in_user) { member.user }
  let(:team) { member.team }
  let(:event) { FactoryGirl.create(:event, :weekly, team: team) }

  describe 'GET #show' do
    subject { response }

    login

    let(:base_params) do
      { team_id: team.to_param, id: event.to_param, format: format }
    end
    let(:params) { base_params }

    before { get :show, params: params }

    context 'as HTML' do
      let(:format) { :html }

      it { is_expected.to be_success }
    end

    context 'as JSON' do
      let(:format) { :json }

      it { is_expected.to be_success }

      describe '#body' do
        subject(:json) { ActiveSupport::JSON.decode(response.body) }

        it { is_expected.to include "occurrence" }

        context 'for a particular date' do
          let(:params) { base_params.merge(year: 2015, month: 12, day: 24) }

          it 'includes the correct occurrence' do
            expect(event.time_zone.parse(json["occurrence"]["starts_at"]))
              .to eq event.starts_at + 1.week
          end
        end

        context 'for a bad date' do
          let(:params) { base_params.merge(year: 2015, month: 12, day: 18) }

          it 'fails' do
            expect(response).to have_http_status(:not_found)
          end
        end
      end
    end
  end
end
