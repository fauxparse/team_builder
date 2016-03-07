require 'rails_helper'

RSpec.describe CalendarController, type: :controller do
  let(:logged_in_user) { member.user }
  let(:member) { FactoryGirl.create(:member) }
  let(:team) { member.team }

  login

  def counts
    ActiveSupport::JSON.decode(response.body).values
  end

  describe 'GET /calendar' do
    context 'as HTML' do
      before { get :index }

      it 'is successful' do
        expect(response).to be_success
      end
    end

    context 'as JSON' do
      before do
        Timecop.freeze(Time.zone.local(2015, 12, 17))
        events
        get :index, format: :json
      end

     context 'with no events' do
        let(:events) { [] }

        it 'renders a list of zeroes' do
          expect(counts).to eq [0] * 31
        end
      end

      context 'with one event' do
        let(:events) { [FactoryGirl.create(:event, :weekly, team: team)] }

        it 'renders ones in the right places' do
          expect(counts).to eq [
                  0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 1, 0, 0,
            0, 0, 0, 0, 1, 0, 0,
            0, 0, 0, 0, 1
          ]
        end
      end

      context 'with two events' do
        let(:events) do
          [
            FactoryGirl.create(:event, team: team),
            FactoryGirl.create(:event, :weekly, team: team)
          ]
        end

        it 'renders ones in the right places' do
          expect(counts).to eq [
                  0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 2, 0, 0,
            0, 0, 0, 0, 1, 0, 0,
            0, 0, 0, 0, 1
          ]
        end
      end
    end
  end
end
