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
    end
  end
end
