class Allocation < ApplicationRecord
  belongs_to :occurrence
  belongs_to :role

  acts_as_list

  validates :occurrence_id, :role_id,
    presence: { allow_blank: false }
  validates :minimum,
    presence: { allow_blank: false },
    numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
