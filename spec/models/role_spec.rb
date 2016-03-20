require 'rails_helper'

RSpec.describe Role, type: :model do
  subject(:role) { Role.new }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name).scoped_to(:team_id) }
  it { is_expected.to validate_presence_of(:team_id) }

  describe '#name' do
    subject { role.name }

    it { is_expected.to eq("participant") }

    context 'when set in the initializer' do
      let(:role) { Role.new(name: "actor") }

      it { is_expected.to eq("actor") }
    end
  end

  describe '#plural' do
    subject { role.plural }

    it { is_expected.to eq("participants") }

    context 'when set in the initializer' do
      let(:role) { Role.new(plural: "actors") }

      it { is_expected.to eq("actors") }
    end
  end
end
