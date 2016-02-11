require 'rails_helper'

RSpec.describe Event, type: :model do
  subject(:event) { FactoryGirl.create(:event) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:slug) }

  describe '#to_param' do
    it 'uses the slug' do
      expect(event.to_param).to eq(event.slug)
    end
  end

  describe '#time_zone' do
    context 'with the default timezone' do
      subject(:event) { FactoryGirl.create(:event, time_zone_name: nil) }

      it 'is the same as the Rails default' do
        expect(event.time_zone).to eq(Time.zone)
      end
    end

    it 'can be set' do
      event.time_zone = ActiveSupport::TimeZone["Melbourne"]
      expect(event.time_zone.name).to eq("Melbourne")
    end

    it 'knows it’s dirty' do
      event.time_zone = ActiveSupport::TimeZone["Melbourne"]
      expect(event.time_zone_changed?).to be true
    end
  end

  describe '#occurrences' do
    subject(:occurrences) { event.occurrences_between(start, stop) }
    let(:time_zone) { event.starts_at.time_zone }
    let(:start) { time_zone.local(2015, 12, 1) }
    let(:stop) { time_zone.local(2016, 1, 1) }

    before do
      event.recurrence_rules.create(repeat_type: :daily)
    end

    it 'generates occurrences according to the schedule' do
      expect(occurrences.count).to eq(15)
    end

    context 'when some are saved' do
      before do
        occurrences.first.save!
      end

      it 'uses the saved versions' do
        expect(event.occurrences_between(start, stop).first)
          .to be_persisted
      end

      context 'and the time zone is changed' do
        before do
          event.update!(time_zone_name: "Sydney")
        end

        it 'fixes the saved occurrences’ time zones' do
          expect(occurrences.first.starts_at)
            .to eq Time.zone.parse("2015-12-17T00:01:00+11:00")
        end
      end

      context 'and the start time is changed' do
        before do
          event.update!(starts_at: "2015-12-17 09:00:00 +1300")
        end

        it 'fixes the occurrences’ times' do
          expect(occurrences.first.starts_at)
            .to eq event.time_zone.parse("2015-12-17T09:00:00+13:00")
        end
      end

      context 'and there are old occurrences hanging around' do
        before do
          event.occurrences.create(starts_at: event.starts_at - 1.week)
        end

        it 'prunes them away' do
          expect { event.update!(starts_at: "2015-12-17 09:00:00 +1300") }
            .to change { Occurrence.count }.by(-1)
        end
      end
    end
  end
end
