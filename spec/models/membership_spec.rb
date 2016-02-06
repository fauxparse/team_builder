require 'rails_helper'

RSpec.describe Membership, type: :model do
  it { is_expected.to validate_presence_of(:team_id) }
  it { is_expected.to validate_presence_of(:user_id) }
end
