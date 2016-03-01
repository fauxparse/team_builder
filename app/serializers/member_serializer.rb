class MemberSerializer < ActiveModel::Serializer
  attributes :id, :name, :admin

  def name
    object.display_name
  end
end
