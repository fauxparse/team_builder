class OccurrenceSerializer < ActiveModel::Serializer
  attributes :team, :event, :name, :starts_at, :stops_at

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

  def name
    object.event.name
  end
end
