class MemberSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :admin
  attribute :errors, if: :has_errors?

  def name
    object.display_name
  end

  def errors
    object.errors.full_messages
  end

  def has_errors?
    object.errors.any?
  end
end
