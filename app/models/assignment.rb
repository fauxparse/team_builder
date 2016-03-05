class Assignment < ApplicationRecord
  belongs_to :allocation
  belongs_to :occurrence
  belongs_to :member

  has_one :event, through: :occurrence

  acts_as_list scope: [:allocation_id, :occurrence_id]

  validates :allocation_id, :occurrence_id, :member_id,
    presence: { allow_blank: false }

  validates :member_id,
    uniqueness: { scope: [:allocation_id, :occurrence_id] }

  def self.most_recent_assignments_for(event)
    joins(:occurrence, :allocation)
      .select(:member_id, :role_id, "MAX(occurrences.starts_at) AS starts_at")
      .where("occurrences.event_id = ?", event.id)
      .group(:member_id, :role_id)
  end
end
