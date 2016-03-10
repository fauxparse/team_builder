require 'mail'

class AddMembersForm
  attr_reader :user, :team, :params

  def initialize(user, team, params)
    @user = user
    @team = team
    @params = params
  end

  def members
    @members ||= addresses.uniq(&:address).map do |address|
      team.members.build(
        display_name: address.display_name || address.local.titleize,
        email: address.address
      )
    end
  end

  def process
    members.each { |member| save_and_invite(member) }
    self
  end

  private

  def save_and_invite(member)
    member.save &&
      InviteMember.new(member, sponsor)
        .on(:success) { |_| }
        .on(:failure) { |_| failed_invitation(member) }
        .call
  end

  def failed_invitation(member)
    member.errors.add(:base, "Couldn’t send invitation")
    member.destroy
  end

  def sponsor
    @sponsor ||= team.members.find_by(user_id: user.id)
  end

  def lines
    params[:members]
      .split("\n")
      .map { |line| line.strip }
  end

  def addresses
    lines.map do |line|
      begin
        Mail::AddressList.new(line).addresses
      rescue Mail::Field::ParseError
        email, name = line.reverse.split(/\s+/, 2).map(&:reverse)
        Struct.new(:address, :display_name).new(email, name)
      end
    end.flatten
  end
end
