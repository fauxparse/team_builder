class Role < ApplicationRecord
  include Defaults

  belongs_to :team

  default(:name) { I18n.t!("activerecord.defaults.role.name") rescue nil }
  default(:plural) { I18n.t!("activerecord.defaults.role.plural") rescue nil }

  before_validation :clear_plural_if_default

  validates :team_id, :name, :plural,
    presence: { allow_blank: false }
  validates :name, :plural,
    uniqueness: { scope: :team_id }

  def plural
    super || name.try(:pluralize)
  end

  private

  def clear_plural_if_default
    self.plural = nil if plural == name.try(:pluralize) || plural.blank?
  end
end
