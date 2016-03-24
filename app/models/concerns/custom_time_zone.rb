module CustomTimeZone
  extend ActiveSupport::Concern

  included do
    validates :time_zone, presence: true
    validates :time_zone_name,
      inclusion: { in: ActiveSupport::TimeZone::MAPPING.keys, allow_nil: true }
  end

  def time_zone
    CustomTimeZone.from_name(time_zone_name)
  end

  def time_zone=(value)
    self.time_zone_name = value.name
  end

  def time_zone?
    time_zone_name.present?
  end

  def time_zone_changed?
    time_zone_name_changed?
  end

  def time_zone_was
    CustomTimeZone.from_name(time_zone_name_was)
  end

  def self.from_name(name)
    name ? ActiveSupport::TimeZone[name] : Time.zone
  end
end
