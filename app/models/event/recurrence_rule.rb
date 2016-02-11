class Event::RecurrenceRule < ApplicationRecord
  belongs_to :event

  enum repeat_type: [
    :never, :daily, :weekly,
    :monthly_by_day, :monthly_by_week,
    :yearly_by_date, :yearly_by_day
  ]

  validates :count,
    numericality: { greater_than: 0, only_integer: true },
    if: :count

  validate :validate_weekdays
  validate :validate_monthly_weeks

  after_update :prune_event_occurrences
  after_destroy :prune_event_occurrences

  def monthly?
    monthly_by_day? || monthly_by_week?
  end

  def yearly?
    yearly_by_day? || yearly_by_date?
  end

  def weekdays
    super.tap do |days|
      days << event.starts_at.wday if days.empty?
    end
  end

  def monthly_weeks
    super.tap do |weeks|
      if weeks.empty?
        weekday = IceCube::TimeUtil::DAYS.invert[event.starts_at.wday]
        weeks << (event.starts_at.day / 7.0).ceil
      end
    end
  end

  private

  def validate_weekdays
    unless weekdays.all? { |d| (0..6).include?(d) }
      errors.add(:weekdays, :invalid)
    end
  end

  def validate_monthly_weeks
    unless monthly_weeks.all? { |d| [-1, 1, 2, 3, 4, 5].include?(d) }
      errors.add(:monthly_weeks, :invalid)
    end
  end

  def prune_event_occurrences
    PruneEventOccurrences.new(event).call
  end
end
