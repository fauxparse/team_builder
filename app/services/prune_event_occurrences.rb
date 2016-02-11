class PruneEventOccurrences
  attr_reader :event

  delegate :occurrences, to: :event

  def initialize(event)
    @event = event
  end

  def call
    event.with_lock do
      schedule = event.schedule(true)

      event.occurrences.select(&:persisted?).each do |occurrence|
        occurrence.destroy! unless schedule.occurs_at?(occurrence.starts_at)
      end
      event.occurrences.reload
    end
  end
end
