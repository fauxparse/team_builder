class AcceptInvitation
  include Shout

  attr_reader :invitation, :user
  delegate :member, to: :invitation

  def initialize(invitation, user)
    @invitation = invitation
    @user = user
  end

  def call
    publish!(:failure) && return unless invitation.pending?

    member.transaction do
      member.update!(user: user)
      invitation.update!(status: :accepted)
      publish!(:success)
    end
  rescue ActiveRecord::RecordInvalid
    publish!(:failure)
  end
end
