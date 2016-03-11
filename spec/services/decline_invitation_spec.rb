require 'rails_helper'

RSpec.describe DeclineInvitation do
  subject(:service) { DeclineInvitation.new(invitation, user) }
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
        .to("declined")
    end

    it 'does not associate the user with the member' do
      expect { service.call }
        .not_to change { member.user }
    end

    it 'publishes success' do
      expect { service.call }
        .to change { @success }
        .from(false)
        .to(true)
    end
  end
end
