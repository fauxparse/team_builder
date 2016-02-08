class ScheduleBuilder
  attr_reader :event

  def initialize(event)
    @event = event
  end

  def schedule
    @schedule ||= blank_schedule.tap do |schedule|
      event.recurrence_rules.each do |rule|
        schedule.add_recurrence_rule(RuleConverter.new(rule).to_ice_cube)
      end
    end
  end

  private

  def blank_schedule
    IceCube::Schedule.new(event.starts_at, duration: event.duration)
  end

  class RuleConverter
    attr_reader :recurrence_rule

    def initialize(recurrence_rule)
      @recurrence_rule = recurrence_rule
    end

    def to_ice_cube
      rule = send(recurrence_rule.repeat_type.to_sym)
      rule = limit(rule) unless recurrence_rule.never?
      rule
    end

    delegate :event, :interval, :weekdays, :monthly_weeks,
      to: :recurrence_rule
    delegate :starts_at, to: :event

    private

    def never
      IceCube::SingleOccurrenceRule.new(starts_at)
    end

    def daily
      IceCube::Rule.daily(interval)
    end

    def weekly
      IceCube::Rule.weekly(interval).day(weekdays)
    end

    def monthly_by_day
      IceCube::Rule.monthly(interval).day_of_month(starts_at.day)
    end

    def monthly_by_week
      weekday = IceCube::TimeUtil::DAYS.invert[event.starts_at.wday]
      IceCube::Rule.monthly(interval)
        .day_of_week(weekday => monthly_weeks)
    end

    def yearly_by_date
      IceCube::Rule.yearly(interval)
    end

    def yearly_by_day
      IceCube::Rule.yearly(interval).day_of_year(starts_at.yday)
    end

    def limit(rule)
      rule
        .count(recurrence_rule.count)
        .until(recurrence_rule.stops_at && recurrence_rule.stops_at - 1.second)
    end
  end
end
