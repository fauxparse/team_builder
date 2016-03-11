class Invitation < ApplicationRecord
  belongs_to :member
  belongs_to :sponsor, class_name: "Member"
  has_one :team, through: :member

  enum status: [:pending, :accepted, :declined]

  before_validation :generate_unique_code, unless: :code?

  validates :code, presence: true, uniqueness: true
  validates :member, :sponsor, presence: true
  validate :members_are_from_the_same_team

  private

  def generate_unique_code
    loop do
      self.code = SecureRandom.urlsafe_base64 
      break unless Invitation.exists?(code: code)
    end
  end

  def members_are_from_the_same_team
    errors.add(:member_id, "must be from the same team") \
      unless member.try(:team_id) == sponsor.try(:team_id)
  end
end
