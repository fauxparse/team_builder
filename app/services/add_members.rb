class AddMembers
  include Shout

  attr_reader :sponsor, :team, :members

  def initialize(sponsor, team, members)
    raise ArgumentError, \
      "#{sponsor.display_name} is not an admin of #{team.name}" \
      unless sponsor.admin_of?(team)

    @sponsor = sponsor
    @team = team
    @members = members
    @succeeded = []
    @failed = []
  end

  def call
    members.each { |member| add(member) }
    publish!(:success, @succeeded) if @succeeded.any?
    publish!(:failure, @failed) if @failed.any?
  end

  private

  def add(member)
    if member.save
      invite_member(member)
    else
      @failed << member
    end
  end

  def invite_member(member)
    InviteMember.new(member, sponsor)
      .on(:success) { |_| @succeeded << member }
      .on(:failure) { |_| invitation_failed(member) }
      .call
  end

  def invitation_failed(member)
    member.errors.add(:base, "Could not invite user")
    @failed << member.destroy
  end
end
