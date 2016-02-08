class Event < ApplicationRecord
  belongs_to :team
  has_many :recurrence_rules, dependent: :destroy
  has_many :occurrences, dependent: :destroy

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
    @time_zone = nil if time_zone_name_changed?
    @time_zone ||= ActiveSupport::TimeZone[time_zone_name]
  end

  def time_zone=(value)
    self.time_zone_name = value.name
  end

  def time_zone_changed?
    time_zone_name_changed?
  end

  def schedule
    @schedule ||= ScheduleBuilder.new(self).schedule
  end

  def starts_at
    super.in_time_zone(time_zone)
  end

  def occurrences_between(start_time, stop_time)
    existing = occurrences.oldest_first
      .between(start_time, stop_time)
      .index_by(&:starts_at)

    schedule.occurrences_between(start_time, stop_time).map do |occurrence|
      time = occurrence.start_time
      existing[time] || occurrences.build(starts_at: time)
    end
  end

  private

  def set_default_time_zone
    self.time_zone_name = Time.zone.name
  end
end
