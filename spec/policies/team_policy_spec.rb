require 'rails_helper'

describe TeamPolicy do
  subject(:policy) { TeamPolicy }

  let(:member) { FactoryGirl.create(:member, admin: true) }
  let(:user) { member.user }
  let(:team) { member.team }
  let(:another_team) { FactoryGirl.create(:team) }

  permissions(:index?, :new?, :create?) do
    it { is_expected.to permit(user, team) }
  end

  permissions(:show?, :edit?, :update?, :destroy?) do
    it { is_expected.to permit(user, team) }
    it { is_expected.not_to permit(user, another_team) }
  end

  describe '#scope' do
    subject(:scope) { policy.new(user, team).scope }

    before do
      2.times { FactoryGirl.create(:team) }
    end

    it { is_expected.to have_exactly(1).item }
    it { is_expected.to match_array([team]) }
  end
end
