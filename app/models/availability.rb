class Availability < ApplicationRecord
  belongs_to :occurrence
  belongs_to :member

  enum enthusiasm: {
    unavailable: 'unavailable',
    possible:    'possible',
    available:   'available',
    keen:        'keen'
  }

  validates :occurrence_id, :member_id, :enthusiasm,
    presence: true
end
