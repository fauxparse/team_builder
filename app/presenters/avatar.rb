require 'digest/md5'

class Avatar
  attr_reader :member
  delegate :user, :email, to: :member

  GRAVATAR_BASE = "http://www.gravatar.com/avatar/"

  def initialize(member)
    @member = member
  end

  def url
    user.try(:avatar_url) || gravatar_url
  end

  private

  def gravatar_url
    GRAVATAR_BASE + Digest::MD5.hexdigest(email.strip.downcase) + "?s=128"
  end
end
