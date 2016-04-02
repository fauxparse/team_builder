class Availability < ApplicationRecord
  belongs_to :occurrence, inverse_of: :availabilities
  belongs_to :member

  enum enthusiasm: {
    unavailable: 'unavailable',
    possible:    'possible',
    available:   'available',
    keen:        'keen'
  }

  validates :occurrence, :member_id, :enthusiasm,
    presence: true
end
