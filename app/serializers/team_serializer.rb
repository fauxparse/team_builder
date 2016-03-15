class TeamSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug
  attribute :errors, if: :has_errors?

  def has_errors?
    object.errors.any?
  end

  def errors
    object.errors.full_messages
  end
end
