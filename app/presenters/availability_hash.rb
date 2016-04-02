class AvailabilityHash
  attr_reader :occurrence

  def initialize(occurrence)
    @occurrence = occurrence
  end

  def to_h
    occurrence.availabilities.each.with_object({}) do |availability, hash|
      hash[availability.member_id] = availability.enthusiasm
    end
  end

  def as_json(options = {})
    to_h
  end
end
