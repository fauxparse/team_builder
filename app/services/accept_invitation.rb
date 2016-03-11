class AcceptInvitation
  include Shout

  attr_reader :invitation, :user
  delegate :member, to: :invitation

  def initialize(invitation, user)
    @invitation = invitation
    @user = user
  end

  def call
    member.transaction do
      member.update!(user: user)
      invitation.update!(status: :accepted)
    end
    publish!(:success)
  rescue
    publish!(:failure)
  end
end
