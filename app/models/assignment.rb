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
end
