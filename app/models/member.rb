class Member < ApplicationRecord
  belongs_to :team
  belongs_to :user, optional: true
  has_many :invitations, dependent: :destroy

  validates :team_id, :display_name,
    presence: { allow_blank: false }

  validates :email,
    format: { with: Devise.email_regexp },
    uniqueness: { scope: :team_id, case_sensitive: false }

  validates :user_id,
    uniqueness: { scope: :team_id },
    if: :user_id?

  validates :admin,
    inclusion: { in: [false] },
    unless: :user_id?

  scope :admin, -> { where(admin: true) }

  def <=>(other)
    display_name <=> other.display_name
  end

  def display_name
    # prefer team-specific display name
    super || user.try(:name)
  end

  def email
    # prefer user's global email address
    user.try(:email) || super
  end

  def admin_of?(team)
    self.team == team && admin?
  end
end
