class Identity < ApplicationRecord
  belongs_to :user

  validates :provider, :uid,
    presence: { allow_blank: false }

  validates :provider,
    uniqueness: { scope: :user_id }
end
