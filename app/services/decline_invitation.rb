class DeclineInvitation
  include Shout

  attr_reader :invitation, :user
  delegate :member, to: :invitation

  def initialize(invitation, user)
    @invitation = invitation
    @user = user
  end

  def call
    if invitation.update(status: :declined)
      publish!(:success)
    else
      publish!(:failure)
    end
  end
end
