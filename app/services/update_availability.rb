class UpdateAvailability
  attr_reader :occurrence

  def initialize(occurrence, availability_hash)
    @occurrence = occurrence
    @availability_hash = availability_hash
  end

  def call
    occurrence.transaction do
      update_availability
      occurrence.touch
    end
  end

  private

  def availabilities
    @availabilities ||= occurrence.availabilities
      .where(member_id: availability_hash.keys)
      .index_by(&:member_id)
  end

  def update_availability
    availability_hash.each_pair do |member_id, enthusiasm|
      if enthusiasm.blank?
        unset(member_id)
      else
        set(member_id, enthusiasm)
      end
    end
  end

  def build_availability(member_id)
    occurrence.availabilities.build(
      member_id: member_id,
      occurrence: occurrence
    )
  end

  def member_ids
    occurrence.event.team.member_ids
  end

  def availability_hash
    @hash ||= hash_with_numeric_keys(@availability_hash).slice(*member_ids)
  end

  def hash_with_numeric_keys(hash)
    {}.tap do |results|
      hash.each_pair { |key, value| results[key.to_i] = value }
    end
  end

  def availability_for(member_id)
    availabilities[member_id] ||= build_availability(member_id)
  end

  def set(member_id, enthusiasm)
    availability_for(member_id).update!(enthusiasm: enthusiasm)
  end

  def unset(member_id)
    availabilities[member_id].try(&:destroy)
  end
end
