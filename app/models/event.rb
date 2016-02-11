class Event < ApplicationRecord
  belongs_to :team
  has_many :recurrence_rules, dependent: :destroy, autosave: true
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

  before_update :fix_occurrence_time_zones, if: :time_zone_changed?
  before_update :fix_occurrence_times, if: :starts_at_changed?

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

  def time_zone_was
    ActiveSupport::TimeZone[time_zone_name_was]
  end

  def schedule(reload = false)
    @schedule = nil if reload
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

  def fix_occurrence_time_zones
    occurrences.select(&:persisted?).each do |occurrence|
      plain_time = occurrence.starts_at
        .in_time_zone(time_zone_was)
        .iso8601.sub(/(Z|[\+\-]\d{2}:\d{2})\z/, "")
      occurrence.update!(starts_at: time_zone.parse(plain_time))
    end
  end

  def fix_occurrence_times
    offset = starts_at - starts_at_was
    @schedule = nil
    occurrences.select(&:persisted?).each do |existing|
      if start_time = time_around(existing.starts_at + offset)
        existing.update!(starts_at: start_time)
      else
        existing.destroy!
      end
    end
    occurrences.reload
  end

  def time_around(start_time, window = 2.hours)
    schedule.occurrences_between(start_time - window, start_time + window)
      .first.try(&:start_time)
  end
end
