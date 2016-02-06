require 'rails_helper'

describe JoinTeam do
  subject(:service) { JoinTeam.new(user, team) }
  let(:user) { FactoryGirl.create(:user) }
  let(:team) { FactoryGirl.create(:team) }

  describe '#call' do
    it 'creates a membership' do
      expect { service.call }.to change { Membership.count }.by(1)
    end

    context 'when the user is already a member' do
      before { Membership.create!(user: user, team: team) }

      it 'does not create a membership' do
        expect(service.call).to be false
      end
    end
  end
end
