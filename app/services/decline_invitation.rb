class DeclineInvitation
  include Shout

  attr_reader :invitation, :user
  delegate :member, to: :invitation

  def initialize(invitation, user)
    @invitation = invitation
    @user = user
  end

  def call
    invitation.update!(status: :declined)
    publish!(:success)
  rescue
    publish!(:failure)
  end
end
