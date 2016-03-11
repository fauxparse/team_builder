require 'rails_helper'

RSpec.describe Member, type: :model do
  let(:team) { member.team }

  context 'without an associated user' do
    subject(:member) { FactoryGirl.build(:newbie) }

    it { is_expected.to be_valid }

    it 'has no associated user' do
      expect(member.user).to be_nil
    end

    it 'cannot be an admin' do
      member.admin = true
      expect(member).not_to be_valid
    end

    context 'without a display_name' do
      before { member.display_name = nil }

      it { is_expected.not_to be_valid }
    end

    context 'without an email address' do
      before { member.email = nil }

      it { is_expected.not_to be_valid }
    end

    describe '#email' do
      it 'uses the member’s email' do
        expect(member.email).to match(/n00b(-\d+)?@resistance\.org/)
      end
    end
  end

  context 'with an associated user' do
    subject(:member) { FactoryGirl.build(:member, user: user) }
    let(:user) { FactoryGirl.create(:poe) }
    let(:display_name) { "Poe D." }

    it { is_expected.to be_valid }

    it 'uses the user’s name for its display_name' do
      expect(member.display_name).to eq "Poe Dameron"
    end

    context 'with its own display_name' do
      before { member.display_name = display_name }

      it 'uses the custom display_name' do
        expect(member.display_name).to eq display_name
      end
    end

    describe '#email' do
      it 'uses the user’s email' do
        expect(member.email).to eq("poe@resistance.org")
      end
    end

    context 'who is already a member of the team' do
      before { team.members.create(user: user) }

      it { is_expected.not_to be_valid }
    end
  end
end
