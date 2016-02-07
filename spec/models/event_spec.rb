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
    it 'has a default' do
      expect(event.time_zone).to eq(Time.zone)
    end

    it 'can be set' do
      event.time_zone = ActiveSupport::TimeZone["Wellington"]
      expect(event.time_zone.name).to eq("Wellington")
    end
  end
end
