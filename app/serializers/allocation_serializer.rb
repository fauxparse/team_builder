class AllocationSerializer < ActiveModel::Serializer
  attributes :id, :name, :minimum, :maximum, :position

  def name
    if object.maximum == 1
      object.role.name
    else
      object.role.plural
    end
  end
end
