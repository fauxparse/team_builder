class Event < ApplicationRecord
  belongs_to :team

  acts_as_url :name,
    url_attribute: :slug,
    only_when_blank: true,
    limit: 32,
    scope: :team_id

  before_validation :set_default_time_zone, unless: :time_zone_name?

  validates :name, :slug,
    presence: { allow_blank: false }

  validates :time_zone_name,
    presence: { allow_blank: false },
    inclusion: { in: ActiveSupport::TimeZone::MAPPING.keys }

  def to_param
    slug
  end

  def time_zone
    @time_zone ||= ActiveSupport::TimeZone[time_zone_name]
  end

  def time_zone=(value)
    self.time_zone_name = value.name
    @time_zone = nil
  end

  private

  def set_default_time_zone
    self.time_zone_name = Time.zone.name
  end
end
