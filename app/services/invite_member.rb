class InviteMember
  include Shout

  attr_accessor :member, :sponsor, :invitation

  def initialize(member, sponsor)
    @member = member
    @sponsor = sponsor
  end

  def call
    @invitation = member.invitations.build(sponsor: sponsor)
    if @invitation.save
      Notifications.invitation(invitation).deliver_later
      publish!(:success, invitation)
    else
      publish!(:failure, invitation)
    end
  end
end
