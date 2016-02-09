class Role < ApplicationRecord
  belongs_to :team

  validates :team_id, :name, :plural,
    presence: { allow_blank: false }
  validates :name, :plural,
    uniqueness: { scope: :team_id }

  def plural
    super || name.try(:pluralize)
  end
end
