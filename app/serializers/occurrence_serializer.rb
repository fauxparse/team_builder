class OccurrenceSerializer < ActiveModel::Serializer
  attributes :event_id, :starts_at, :name

  def starts_at
    object.starts_at.iso8601
  end

  def name
    object.event.name
  end
end
