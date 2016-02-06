class Member < ApplicationRecord
  belongs_to :team
  belongs_to :user, optional: true

  validates :team_id, :display_name,
    presence: { allow_blank: false }

  validates :user_id,
    uniqueness: { scope: :team_id },
    if: :user_id?

  validates :admin,
    inclusion: { in: [false] },
    unless: :user_id?

  def display_name
    super || user.try(:name)
  end
end
