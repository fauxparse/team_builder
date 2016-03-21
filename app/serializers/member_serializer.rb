class MemberSerializer < ApplicationSerializer
  attributes :id, :name, :email, :admin

  def name
    object.display_name
  end
end
