class Role < ApplicationRecord
  include Defaults

  belongs_to :team

  default(:name) { I18n.t!("activerecord.defaults.role.name") rescue nil }
  default(:plural) { I18n.t!("activerecord.defaults.role.plural") rescue nil }

  validates :team_id, :name, :plural,
    presence: { allow_blank: false }
  validates :name, :plural,
    uniqueness: { scope: :team_id }

  def plural
    super || name.try(:pluralize)
  end
end
