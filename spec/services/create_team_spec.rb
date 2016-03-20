require 'rails_helper'

describe CreateTeam do
  subject(:service) do
    CreateTeam.new(user, attributes).on(:success, :failure) {}
  end
  let(:attributes) { FactoryGirl.attributes_for(:team) }
  let(:user) { FactoryGirl.create(:user) }

  describe '#call' do
    before do
      service.on(:success) { |team| @member = team.members.last }
    end

    it 'creates a team' do
      expect { service.call }.to change { Team.count }.by(1)
    end

    it 'creates a member' do
      expect { service.call }.to change { Member.count }.by(1)
    end

    it 'creates a role' do
      expect { service.call }.to change { Role.count }.by(1)
    end

    it 'adds the user to the team' do
      service.call
      expect(@member.user).to eq(user)
    end

    it 'adds the user as an admin' do
      service.call
      expect(@member).to be_admin
    end
  end
end
