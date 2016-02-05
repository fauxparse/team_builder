class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable,
         :omniauthable, :omniauth_providers => [:google_oauth2]

  has_many :identities, dependent: :destroy

  validates :name, presence: { allow_blank: false }
end
