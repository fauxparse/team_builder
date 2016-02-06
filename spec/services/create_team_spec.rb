require 'rails_helper'

describe CreateTeam do
  subject(:service) { CreateTeam.new(user, attributes) }
  let(:attributes) { FactoryGirl.attributes_for(:team) }
  let(:user) { FactoryGirl.create(:user) }
  let(:membership) { service.team.memberships.last }

  describe '#call' do
    it 'creates a team' do
      expect { service.call }.to change { Team.count }.by(1)
    end

    it 'creates a membership' do
      expect { service.call }.to change { Membership.count }.by(1)
    end

    it 'adds the user to the team' do
      service.call
      expect(membership.user).to eq(user)
    end

    it 'adds the user as an admin' do
      service.call
      expect(membership).to be_admin
    end
  end
end
