class RecordAvailability
  attr_reader :member, :event, :time, :enthusiasm

  def initialize(member, event, time, enthusiasm = :available)
    @member = member
    @event = event
    @time = time
    @enthusiasm = enthusiasm
  end

  def call
    valid_occurrence_time? && availability.update!(enthusiasm: enthusiasm)
  end

  private

  def availability
    @availability = occurrence.availabilities
      .find_or_initialize_by(member: member)
  end

  def occurrence
    @occurrence = event.occurrences.find_or_create_by(starts_at: time)
  end

  def valid_occurrence_time?
    event.schedule.occurs_at?(time)
  end
end
