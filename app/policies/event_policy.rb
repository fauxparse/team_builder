class EventPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope
        .joins(team: :members)
        .where("members.user_id = ?", user.id)
    end
  end
end
