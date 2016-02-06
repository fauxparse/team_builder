require 'rails_helper'

describe JoinTeam do
  subject(:service) { JoinTeam.new(user, team) }
  let(:user) { FactoryGirl.create(:user) }
  let(:team) { FactoryGirl.create(:team) }

  describe '#call' do
    it 'creates a member' do
      expect { service.call }.to change { Member.count }.by(1)
    end

    context 'when the user is already a member' do
      before { Member.create!(user: user, team: team) }

      it 'does not create a member' do
        expect(service.call).to be false
      end
    end
  end
end
