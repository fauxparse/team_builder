class JoinTeam
  attr_reader :user, :team, :admin, :member

  def initialize(user, team, admin = false)
    @user = user
    @team = team
    @admin = admin
  end

  def call
    @member = Member.create!(
      user: user,
      team: team,
      admin: admin
    )
  rescue ActiveRecord::RecordInvalid
    return false
  end
end
