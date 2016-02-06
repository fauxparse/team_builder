class Team < ApplicationRecord
  has_many :memberships, dependent: :destroy

  acts_as_url :name,
    url_attribute: :slug,
    only_when_blank: true,
    limit: 32

  validates :name, :slug,
    presence: { allow_blank: false }

  def to_param
    slug
  end
end
