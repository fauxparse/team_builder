require 'rails_helper'

RSpec.describe Occurrence, type: :model do
  it { is_expected.to validate_presence_of(:starts_at) }
  it { is_expected.to validate_uniqueness_of(:starts_at).scoped_to(:event_id) }
end
