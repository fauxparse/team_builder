class JoinTeam
  attr_reader :user, :team, :admin

  def initialize(user, team, admin = false)
    @user = user
    @team = team
    @admin = admin
  end

  def call
    @membership = Membership.create!(
      user: user,
      team: team,
      admin: admin
    )
  rescue ActiveRecord::RecordInvalid
    return false
  end
end
