module ApplicationHelper
  def serialize(resource, options = {})
    resource && ActiveModel::SerializableResource.new(resource, options).as_json
  end
end
