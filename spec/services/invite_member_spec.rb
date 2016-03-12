require 'rails_helper'

RSpec.describe InviteMember do
  subject(:invite) { InviteMember.new(member, sponsor) }
  let(:sponsor) { FactoryGirl.create(:member) }
  let(:member) { FactoryGirl.create(:newbie, team: team) }
  let(:team) { sponsor.team }
  let(:expected_status) { :success }

  before do
    expect(invite)
      .to receive(:publish!)
      .with(expected_status, instance_of(Invitation))
      .and_return(invite)
  end

  describe '#call' do
    it 'creates an invitation' do
      expect { invite.call }.to change { Invitation.count }.by(1)
    end

    it 'sends an invitation email' do
      expect(Notifications)
        .to receive(:invitation)
        .at_least(:once)
        .with(instance_of(Invitation))
        .and_call_original
      invite.call
    end

    context 'when the sponsor and the member are from different teams' do
      let(:team) { FactoryGirl.create(:team) }
      let(:expected_status) { :failure }

      it 'does not create an invitation' do
        expect { invite.call }.not_to change { Invitation.count }
      end
    end
  end
end
