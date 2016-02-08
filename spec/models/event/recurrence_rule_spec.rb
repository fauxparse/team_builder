require 'rails_helper'

RSpec.describe Event::RecurrenceRule, type: :model do
  subject(:rule) { FactoryGirl.create(rule_type) }
  let(:rule_type) { :recurrence_rule }

  it { is_expected.to validate_numericality_of(:count).is_greater_than(0) }

  describe '#weekdays' do
    it 'doesn’t allow negatives' do
      rule.weekdays = [-1]
      expect(rule).to have(1).error_on(:weekdays)
    end

    it 'doesn’t allow numbers over 6' do
      rule.weekdays = [7]
      expect(rule).to have(1).error_on(:weekdays)
    end
  end

  describe '#monthly_weeks' do
    it 'is validated' do
      rule.monthly_weeks = [0]
      expect(rule).to have(1).error_on(:monthly_weeks)
    end
  end
end
