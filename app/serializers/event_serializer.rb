class EventSerializer < ApplicationSerializer
  attributes :id, :name, :slug, :starts_at, :stops_at, :duration
  attribute :occurrence, if: :include_occurrence?

  def occurrence
    child(instance_options[:occurrence] || object.first_occurrence)
  end

  def include_occurrence?
    instance_options[:occurrence].present?
  end
end
