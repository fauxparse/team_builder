class TeamSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug
  attribute :errors, if: :has_errors?

  def has_errors?
    object.errors.any?
  end

  def errors
    messages = object.errors.map do |attr, _|
      [attr, object.errors.full_messages_for(attr)]
    end
    Hash[messages]
  end
end
