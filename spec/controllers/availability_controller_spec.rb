require 'rails_helper'

RSpec.describe AvailabilityController, type: :controller do
  let(:member) { FactoryGirl.create(:member) }
  let(:logged_in_user) { member.user }
  let(:team) { member.team }
  let(:event) { FactoryGirl.create(:event, :weekly, team: team) }

  let(:params) do
    {
      team_id: team.to_param,
      event_id: event.to_param,
      format: :json,
      year: 2015,
      month: 12,
      day: 17
    }
  end

  def parameters(attrs)
    ActionController::Parameters.new(attrs).tap do |params|
      params.send :permitted=, true
    end
  end

  login

  describe 'GET #show' do
    let(:request) { get :show, params: params }

    describe '#response' do
      subject { request && response }

      it { is_expected.to be_success }

      describe '#body' do
        subject { request && ActiveSupport::JSON.decode(response.body) }

        it { is_expected.to eq({}) }

        context 'with availability recorded' do
          before do
            UpdateAvailability.new(
              event.first_occurrence,
              { member.id => "possible" }
            ).call
          end

          it { is_expected.to eq(member.id.to_s => "possible") }
        end
      end

      context 'for a bad date' do
        let(:params) do
          {
            team_id: team.to_param,
            event_id: event.to_param,
            format: :json,
            year: 2015,
            month: 12,
            day: 18
          }
        end

        it { is_expected.to be_not_found }
      end
    end
  end

  describe 'PUT #update' do
    let(:request) { put :update, params: params.merge(update) }
    let(:update) { { availability: { member.id => "available" } } }

    describe '#request' do
      it 'calls UpdateAvailability' do
        expect(UpdateAvailability)
          .to receive(:new)
          .with(
            an_instance_of(Occurrence),
            parameters(member.id.to_s => "available")
          )
          .and_call_original
        request
      end

      it 'adds an availability record' do
        expect { request }
          .to change { Availability.count }
          .from(0)
          .to(1)
      end
    end

    describe '#response' do
      subject { request && response }

      it { is_expected.to be_success }

      describe '#body' do
        subject { request && ActiveSupport::JSON.decode(response.body) }

        let(:json) { { member.id.to_s => "available" } }

        it { is_expected.to eq json }
      end
    end

    context 'when availability has already been recorded' do
      before do
        UpdateAvailability.new(
          event.first_occurrence,
          member.id => "possible"
        ).call
      end

      describe '#response' do
        subject { request && response }

        it { is_expected.to be_success }
      end

      describe '#request' do
        it 'updates availability' do
          expect { request }
            .to change { Availability.first.enthusiasm }
            .from("possible")
            .to("available")
        end

        it 'does not create a new Availability record' do
          expect { request }
            .not_to change { Availability.count }
        end
      end
    end
  end
end
