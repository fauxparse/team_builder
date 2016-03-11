require 'rails_helper'

RSpec.describe AcceptInvitation do
  subject(:service) { AcceptInvitation.new(invitation, user) }
  let(:member) { FactoryGirl.create(:newbie) }
  let(:user) { FactoryGirl.create(:user) }
  let(:sponsor) { FactoryGirl.create(:member, team: team) }
  let(:team) { member.team }
  let(:invitation) { Invitation.create!(member: member, sponsor: sponsor) }

  before do
    @success = @failure = false
    service
      .on(:success) { @success = true }
      .on(:failure) { @failure = true }
  end

  describe '#call' do
    it 'changes the status of the invitation' do
      expect { service.call }
        .to change { invitation.status }
        .from("pending")
        .to("accepted")
    end

    it 'associates the user with the member' do
      expect { service.call }
        .to change { member.user }
        .from(nil)
        .to(user)
    end

    it 'publishes success' do
      expect { service.call }
        .to change { @success }
        .from(false)
        .to(true)
    end

    context 'when the new user is already in the team' do
      before { team.members.create(user: user) }

      it 'does not change the status of the invitation' do
        expect { service.call }
          .not_to change { invitation.status }
      end

      it 'does not associate the user with the member' do
        expect { service.call }
          .not_to change { member.reload.user }
      end

      it 'publishes failure' do
        expect { service.call }
          .to change { @failure }
          .from(false)
          .to(true)
      end
    end
  end
end
