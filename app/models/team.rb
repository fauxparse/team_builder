class Team < ApplicationRecord
  has_many :members, dependent: :destroy
  has_many :roles, dependent: :destroy
  has_many :events, inverse_of: :team, dependent: :destroy

  acts_as_url :name,
    url_attribute: :slug,
    only_when_blank: true,
    limit: 32

  validates :name, :slug,
    presence: true

  def to_param
    slug
  end
end
