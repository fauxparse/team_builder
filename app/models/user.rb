class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, :omniauth_providers => [:google_oauth2]

  has_many :identities, dependent: :destroy
  has_many :members
  has_many :teams, through: :members

  validates :name, presence: { allow_blank: false }

  before_destroy :save_attributes_on_associated_members

  private

  def save_attributes_on_associated_members
    members.each do |member|
      member.update!(
        display_name: member.display_name == name ? name : member.display_name,
        email: email,
        user_id: nil
      )
    end
  end
end
