class MemberSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :admin
  attribute :errors, if: :has_errors?

  def name
    object.display_name
  end

  def errors
    messages = object.errors.map do |attr, _|
      [attr, object.errors.full_messages_for(attr)]
    end
    Hash[messages]
  end

  def has_errors?
    object.errors.any?
  end
end
