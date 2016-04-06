class EventSerializer < ApplicationSerializer
  attributes :id, :name, :slug, :starts_at, :stops_at, :duration
  attribute :occurrence, if: :include_occurrence?
  has_many :allocations, if: :include_allocations?

  def occurrence
    child(
      instance_options[:occurrence] || object.first_occurrence,
      include_availability: true
    )
  end

  def include_occurrence?
    instance_options[:occurrence].present?
  end

  def include_allocations?
    object.allocations.loaded?
  end
end
