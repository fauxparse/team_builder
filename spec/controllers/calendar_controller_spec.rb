require 'rails_helper'

RSpec.describe CalendarController, type: :controller do
  let(:logged_in_user) { member.user }
  let(:member) { FactoryGirl.create(:member) }
  let(:team) { member.team }
  let(:json) { ActiveSupport::JSON.decode(response.body) }

  login

  def counts
    json.values
  end

  def keys
    json.keys.sort
  end

  describe 'GET /calendar' do
    context 'as HTML' do
      before { get :index }

      it 'is successful' do
        expect(response).to be_success
      end
    end

    context 'as JSON' do
      let(:params) { {} }

      before do
        Timecop.freeze(Time.zone.local(2015, 12, 17))
        events
        get :index, params: params.merge(format: :json)
      end

      context 'with no events' do
        let(:events) { [] }

        it 'renders a list of zeroes' do
          expect(counts).to eq [0] * 31
        end

        it 'has the expected keys' do
          start = Time.zone.now.beginning_of_month.to_date
          stop = start + 1.month
          expect(keys)
            .to eq (start...stop).map { |date| date.strftime("%Y-%m-%d") }
        end

        context 'and a year set' do
          let(:params) { { year: 2017 } }

          it 'gets the right year' do
            expect(keys.first).to eq "2017-01-01"
          end

          context 'and a month set' do
            let(:params) { { year: 2017, month: 7 } }

            it 'gets the right year' do
              expect(keys.first).to eq "2017-07-01"
            end
          end
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

        context 'within a team context' do
          let(:another_team) { FactoryGirl.create(:team) }
          let(:params) { { team_id: another_team.id } }

          it 'renders a list of zeroes' do
            expect(counts).to eq [0] * 31
          end
        end
      end
    end
  end
end
