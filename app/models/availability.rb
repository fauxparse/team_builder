class Availability < ApplicationRecord
  belongs_to :occurrence
  belongs_to :member

  enum enthusiasm: [:unavailable, :possible, :available, :keen]

  validates :occurrence_id, :member_id, :enthusiasm,
    presence: { allow_blank: false }

  def possible?
    !unavailable?
  end

  def available?
    [:available, :keen].include?(enthusiasm)
  end
end
