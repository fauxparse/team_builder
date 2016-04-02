require 'rails_helper'

RSpec.describe Availability, type: :model do
  it { is_expected.to validate_presence_of :occurrence }
  it { is_expected.to validate_presence_of :member_id }
  it { is_expected.to validate_presence_of :enthusiasm }
end
