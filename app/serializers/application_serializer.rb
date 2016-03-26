class ApplicationSerializer < ActiveModel::Serializer
  attribute :errors, if: :has_errors?

  def errors
    messages = object.errors.map do |attr, _|
      [attr, object.errors.full_messages_for(attr)]
    end
    Hash[messages]
  end

  def has_errors?
    object.errors.any?
  end

  def child(resource, options = {})
    ActiveModel::SerializableResource.new(resource, options).as_json
  end
end
