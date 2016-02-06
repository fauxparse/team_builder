class Membership < ApplicationRecord
  belongs_to :team
  belongs_to :user

  validates :team_id, :user_id,
    presence: { allow_blank: false }

  validates :user_id,
    uniqueness: { scope: :team_id }
end
