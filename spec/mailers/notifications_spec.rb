require "rails_helper"

RSpec.describe Notifications, type: :mailer do
  describe '#invitation' do
    let(:newbie) { FactoryGirl.create(:newbie) }
    let(:team) { newbie.team }
    let(:admin) { FactoryGirl.create(:member, :admin, team: team) }
    let(:invitation) { Invitation.create!(member: newbie, sponsor: admin) }
    let(:email) { Notifications.invitation(invitation) }

    describe '#subject' do
      subject { email.subject }
      it { is_expected.to include team.name }
    end

    describe '#from' do
      subject { email.from }
      it { is_expected.to include admin.email }
    end

    describe '#to' do
      subject { email.to }
      it { is_expected.to include newbie.email }
    end

    describe '#body' do
      subject { email.body }
      it { is_expected.to include "Hi #{newbie.display_name}" }
      it { is_expected.to include invitation.code }
    end
  end
end
