require 'rails_helper'

RSpec.describe Team, type: :model do
  subject(:team) { FactoryGirl.create(:team) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:slug) }

  describe '#to_param' do
    it 'returns the slug, not the ID' do
      expect(team.to_param).to eq(team.slug)
    end
  end
end
