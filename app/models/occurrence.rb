class Occurrence < ApplicationRecord
  belongs_to :event
  has_many :availabilities, dependent: :destroy, autosave: true

  validates :starts_at,
    presence: { allow_blank: false },
    uniqueness: { scope: :event_id }

  scope :oldest_first, -> { order(starts_at: :asc) }
  scope :between, ->(start, stop) {
    where("starts_at >= ? AND starts_at < ?", start, stop)
  }
end
