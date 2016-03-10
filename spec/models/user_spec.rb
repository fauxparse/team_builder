require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to validate_presence_of :name }

  describe '#destroy' do
    subject(:user) { member.user }
    let(:member) { FactoryGirl.create(:member) }

    before do
      user.destroy
      member.reload
    end

    it 'bequeaths its name to associated members' do
      expect(member.send(:read_attribute, :display_name))
        .to eq(user.name)
    end

    it 'bequeaths its email to associated members' do
      expect(member.send(:read_attribute, :email))
        .to eq(user.email)
    end
  end
end
