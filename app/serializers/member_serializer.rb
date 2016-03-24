class MemberSerializer < ApplicationSerializer
  attributes :id, :name, :email, :admin, :avatar

  def name
    object.display_name
  end

  def avatar
    Avatar.new(object).url
  end
end
