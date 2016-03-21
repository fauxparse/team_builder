class RoleSerializer < ApplicationSerializer
  attributes :id, :name, :plural, :default_plural

  def default_plural
    object.name.try(:pluralize)
  end
end
