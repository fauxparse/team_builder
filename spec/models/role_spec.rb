require 'rails_helper'

RSpec.describe Role, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name).scoped_to(:team_id) }
  it { is_expected.to validate_presence_of(:plural) }
  it { is_expected.to validate_presence_of(:team_id) }
end
