class Allocation < ApplicationRecord
  belongs_to :event
  belongs_to :role

  acts_as_list

  validates :event_id, :role_id, presence: true
  validates :minimum, presence: true,
    numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :maximum,
    numericality: { only_integer: true, greater_than_or_equal_to: 0, allow_blank: true }

  def unlimited?
    maximum.blank?
  end
end
