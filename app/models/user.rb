class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable,
         :omniauthable, :omniauth_providers => [:google_oauth2]

  has_many :identities, dependent: :destroy
  has_many :members
  has_many :teams, through: :members

  validates :name, presence: { allow_blank: false }

  def is_admin_for?(team)
    members.admin.exists?(team_id: team.id)
  end
end
