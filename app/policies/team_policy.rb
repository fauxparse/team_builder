class TeamPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      user.teams
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
