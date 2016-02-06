require 'rails_helper'

RSpec.describe Member, type: :model do
  subject(:member) { Member.new(user: user, team: team) }
  let(:team) { FactoryGirl.create(:team) }
  let(:display_name) { "Poe D." }

  context 'without an associated user' do
    let(:user) { nil }

    before { member.display_name = display_name }

    it { is_expected.to be_valid }

    it 'cannot be an admin' do
      member.admin = true
      expect(member).not_to be_valid
    end

    context 'without a display_name' do
      let(:display_name) { nil }

      it { is_expected.not_to be_valid }
    end
  end

  context 'with associated user' do
    let(:user) { FactoryGirl.create(:user) }

    it { is_expected.to be_valid }

    it 'uses the user’s name for its display_name' do
      expect(member.display_name).to eq user.name
    end

    context 'with its own display_name' do
      before { member.display_name = display_name }

      it 'uses the custom display_name' do
        expect(member.display_name).to eq display_name
      end
    end
  end
end
