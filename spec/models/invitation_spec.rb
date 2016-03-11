require 'rails_helper'

RSpec.describe Invitation, type: :model do
  subject(:invitation) { member.invitations.build(sponsor: sponsor) }
  let(:member) { FactoryGirl.create(:newbie) }
  let(:sponsor) { FactoryGirl.create(:member, team: member.team) }

  it { is_expected.to be_valid }
  it { is_expected.to validate_uniqueness_of(:code) }
  it { is_expected.to be_pending }

  context 'when the member and the sponsor are from different teams' do
    let(:sponsor) { FactoryGirl.create(:member) }

    it { is_expected.not_to be_valid }
  end
end
