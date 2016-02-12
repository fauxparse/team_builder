require 'rails_helper'

RSpec.describe Allocation, type: :model do
  it { is_expected.to validate_presence_of(:event_id) }
  it { is_expected.to validate_presence_of(:role_id) }
  it { is_expected.to validate_presence_of(:minimum) }
  it { is_expected.to validate_numericality_of(:minimum)
    .is_greater_than_or_equal_to(0) }
end
