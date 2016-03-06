class EventsBetween
  attr_reader :start_time, :stop_time, :scope

  def initialize(start, stop, scope = Event)
    @start_time = start
    @stop_time = stop
    @scope = scope
  end

  def events
    @events ||= scope.between(start_time, stop_time)
  end

  def counts_by_day
    today = start_time.dup.beginning_of_day
    {}.tap do |results|
      while today < stop_time
        tomorrow = today + 1.day
        results[today.strftime('%Y-%m-%d')] = count_between(today, tomorrow)
        today = tomorrow
      end
    end
  end

  private

  def count_between(start, stop)
    occurrences = events.map do |event|
      event.schedule.occurrences_between(start, stop).size
    end
    occurrences.sum
  end
end
