class OccurrenceSerializer < ActiveModel::Serializer
  attributes :team, :event, :name, :starts_at, :stops_at, :next, :previous
  attribute :availability, if: :include_availability?

  def name
    object.event.name
  end

  def team
    object.event.team.to_param
  end

  def event
    object.event.to_param
  end

  def starts_at
    object.starts_at.iso8601
  end

  def stops_at
    object.stops_at.iso8601
  end

  def previous
    object.previous_starts_at.try(&:iso8601)
  end

  def next
    object.next_starts_at.try(&:iso8601)
  end

  def include_availability?
    !!instance_options[:include_availability]
  end

  def availability
    AvailabilityHash.new(object).to_h
  end
end
