class UserFromOauth
  attr_reader :auth

  def initialize(auth)
    @auth = auth
  end

  def user
    identity.user
  end

  def identity
    @identity ||= find_or_create_user.identities.find_or_create_by!(
      provider: auth.provider,
      uid: auth.uid
    )
  end

  private

  def find_or_create_user
    User.find_by(email: auth.info.email) || create_user
  end

  def create_user
    User.new(name: auth.info.name, email: auth.info.email).tap do |user|
      user.password = Devise.friendly_token[0,20]
      user.skip_confirmation! if User.devise_modules.include?(:confirmable)
      user.save!
    end
  end
end
