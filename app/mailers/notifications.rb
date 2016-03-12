require 'mail'

class Notifications < ApplicationMailer
  def invitation(invitation)
    @invitation = invitation

    mail(
      to: member_address(invitation.member),
      from: member_address(invitation.sponsor),
      subject: "Invitation to join #{invitation.member.team.name}"
    )
  end

  private

  def member_address(member)
    Mail::Address.new(member.email).tap do |email|
      email.display_name = member.display_name.dup
    end
  end
end
