class TeamPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope
        .joins(:members)
        .where("members.user_id = ?", user.id)
    end
  end

  alias :team :record

  def create?
    true
  end

  def edit?
    update?
  end

  def update?
    member.persisted? && member.admin?
  end

  def destroy?
    update?
  end

  def member
    @member ||= user.members.find_by(team_id: team.id) ||
      user.members.build(team: team)
  end
end
