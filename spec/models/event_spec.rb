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

  describe '#starts_at' do
    context 'for a new event' do
      subject { Event.new.starts_at }

      it { is_expected.to be_nil }
    end
  end

  describe '#time_zone' do
    context 'when the event is newly initialized' do
      subject { Event.new.time_zone }

      it { is_expected.to be_present }
      it { is_expected.to eq Time.zone }
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

  describe '#time_zone?' do
    context 'when the event is newly initialized' do
      subject { Event.new.time_zone? }
      it { is_expected.to be false }
    end

    context 'when a timezone has been assigned' do
      subject { Event.new(time_zone_name: "Sydney").time_zone? }
      it { is_expected.to be true }
    end
  end

  describe '#time_zone_was' do
    subject { event.time_zone_was }
    before { event.time_zone = ActiveSupport::TimeZone["Melbourne"] }
    it { is_expected.to eq Time.zone }
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
      before { occurrences.first.save! }

      it 'uses the saved versions' do
        expect(event.occurrences_between(start, stop).first)
          .to be_persisted
      end

      context 'and the time zone is changed' do
        before { event.update!(time_zone_name: "Sydney") }

        it 'fixes the saved occurrences’ time zones' do
          expect(occurrences.first.starts_at)
            .to eq Time.zone.parse("2015-12-17T00:01:00+11:00")
        end
      end

      context 'and the start time is changed' do
        before { event.update!(starts_at: "2015-12-17 09:00:00 +1300") }

        it 'fixes the occurrences’ times' do
          expect(occurrences.first.starts_at)
            .to eq event.time_zone.parse("2015-12-17T09:00:00+13:00")
        end
      end

      context 'and there are old occurrences hanging around' do
        before { event.occurrences.create(starts_at: event.starts_at - 1.week) }

        it 'prunes them away' do
          expect { event.update!(starts_at: "2015-12-17 09:00:00 +1300") }
            .to change { Occurrence.count }.by(-1)
        end
      end
    end
  end

  describe '#first_occurrence' do
    subject { event.first_occurrence }

    it { is_expected.to be_valid }
  end

  describe '#occurrence_on' do
    subject(:occurrence) { event.occurrence_on(date) }

    context 'for the date the event starts' do
      let(:date) { Date.new(2015, 12, 17) }

      it { is_expected.to be_an_instance_of Occurrence }

      it 'has the right time' do
        expect(occurrence.starts_at).to eq event.starts_at
      end
    end

    context 'for a bad date' do
      let(:date) { Date.new(2015, 12, 12) }

      it { is_expected.to be_nil }
    end

    context 'for a weekly event' do
      let(:event) { FactoryGirl.create(:event, :weekly) }
      let(:date) { Date.new(2015, 12, 24) }

      it { is_expected.to be_an_instance_of Occurrence }

      it 'has the right time' do
        expect(occurrence.starts_at).to eq event.starts_at + 1.week
      end
    end
  end
end
