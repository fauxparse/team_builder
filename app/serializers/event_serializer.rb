class EventSerializer < ApplicationSerializer
  attributes :id, :name, :slug, :starts_at, :stops_at, :duration
  attributes :repeat_type
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

  def repeat_type
    recurrence_rule.try(:repeat_type) || "never"
  end

  private

  def recurrence_rule
    @recurrence_rule ||= object.recurrence_rules.first
  end
end
