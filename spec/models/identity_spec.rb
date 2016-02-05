require 'rails_helper'

RSpec.describe Identity, type: :model do
  it { is_expected.to validate_presence_of(:provider) }
  it { is_expected.to validate_presence_of(:uid) }
  it { is_expected.to validate_uniqueness_of(:provider).scoped_to(:user_id) }
end
