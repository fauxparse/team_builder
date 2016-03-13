module MembershipHelpers
  def team
    @team ||= FactoryGirl.create(:team)
  end

  def admin
    @admin ||= FactoryGirl.create(:member, :admin, team: team)
  end

  def new_member
    @member ||= FactoryGirl.create(:newbie, team: team).tap do |member|
      member.update!(email: @user.email) if @user.present?
    end
  end

  def user
    @user ||= FactoryGirl.create(:user)
  end
end

World(MembershipHelpers)
