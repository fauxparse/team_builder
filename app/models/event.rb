class Event < ApplicationRecord
  include CustomTimeZone

  belongs_to :team, inverse_of: :events
  has_many :recurrence_rules, dependent: :destroy, autosave: true
  has_many :occurrences, inverse_of: :event, dependent: :destroy
  has_many :allocations, dependent: :destroy, autosave: true

  acts_as_url :name,
    url_attribute: :slug,
    only_when_blank: true,
    limit: 32,
    scope: :team_id

  validates :name, :slug,
    presence: true

  before_update :fix_occurrence_time_zones, if: :time_zone_changed?
  before_update :fix_occurrence_times, if: :starts_at_changed?

  def to_param
    slug
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

  def first_occurrence
    occurrences_between(starts_at, starts_at).first
  end

  def self.between(start_time, stop_time)
    where(
      "starts_at < :stop AND (stops_at IS NULL OR stops_at > :start)",
      start: start_time, stop: stop_time
    )
  end

  private

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
      start_time = time_around(existing.starts_at + offset)
      if start_time.present?
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
