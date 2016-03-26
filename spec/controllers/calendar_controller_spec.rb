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
          let(:another_team) do
            FactoryGirl.create(:team).tap do |another|
              Member.create!(user: logged_in_user, team: another)
            end
          end
          let(:params) { { team_id: another_team.slug } }

          it 'renders a list of zeroes' do
            expect(counts).to eq [0] * 31
          end
        end
      end
    end
  end

  describe 'GET /calendar/:year/:month/:day' do
    let(:params) do
      {
        year: events.first.starts_at.year,
        month: events.first.starts_at.month,
        day: events.first.starts_at.day,
        team_id: team.to_param
      }
    end

    context 'as JSON' do
      before { get :show, params: params.merge(format: :json) }

      context 'with two events' do
        let(:events) do
          [
            FactoryGirl.create(:event, team: team,
                               starts_at: "2015-12-17 10:00:00 +1300"),
            FactoryGirl.create(:event, :weekly, team: team)
          ]
        end

        describe '#response' do
          subject { response }

          it { is_expected.to be_success }
        end

        describe 'response#body' do
          subject { ActiveSupport::JSON.decode(response.body) }

          let(:expected_json) do
            [
              {
                "team"      => team.to_param,
                "event"     => events.last.to_param,
                "name"      => events.last.name,
                "starts_at" => events.last.starts_at.iso8601,
                "stops_at"  => (events.last.starts_at + events.last.duration)
                                 .iso8601,
                "next"      => "2015-12-24T00:01:00+13:00",
                "previous"  => nil
              },
              {
                "team"      => team.to_param,
                "event"     => events.first.to_param,
                "name"      => events.first.name,
                "starts_at" => events.first.starts_at.iso8601,
                "stops_at"  => (events.first.starts_at + events.last.duration)
                                 .iso8601,
                "next"      => nil,
                "previous"  => nil
              }
            ]
          end

          it { is_expected.to have_exactly(2).items }
          it { is_expected.to eq expected_json }
        end
      end
    end
  end
end
