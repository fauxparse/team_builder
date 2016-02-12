require 'rails_helper'

RSpec.describe Assignment, type: :model do
  subject(:assignment) { Assignment.new(attributes) }
  let(:attributes) do
    { allocation: allocation, occurrence: occurrence, member: member }
  end
  let(:event) { FactoryGirl.create(:event, :with_pilots) }
  let(:member) { FactoryGirl.create(:member, team: team) }
  let(:team) { event.team }
  let(:allocation) { event.allocations.first }
  let(:role) { allocation.role }
  let(:occurrence) { event.first_occurrence }

  it { is_expected.to validate_presence_of :allocation_id }
  it { is_expected.to validate_presence_of :occurrence_id }
  it { is_expected.to validate_presence_of :member_id }

  context 'when it already exists in the database' do
    before { Assignment.create(attributes) }
    it { is_expected.not_to be_valid }
  end
end
