class Occurrence < ApplicationRecord
  belongs_to :event, inverse_of: :occurrences
  has_many :availabilities, dependent: :destroy, autosave: true
  has_many :assignments, dependent: :destroy, autosave: true
  has_many :available_members, through: :availabilities,
    class_name: "Member", source: :member

  validates :starts_at,
    presence: true,
    uniqueness: { scope: :event_id }

  scope :oldest_first, -> { order(starts_at: :asc) }
  scope :between, ->(start, stop) {
    where("starts_at >= ? AND starts_at < ?", start, stop)
  }

  def stops_at
    starts_at + event.duration.seconds
  end
end
