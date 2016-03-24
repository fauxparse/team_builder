class MemberSerializer < ApplicationSerializer
  attributes :id, :name, :email, :admin
  attribute :avatar, if: :persisted?

  delegate :persisted?, to: :object

  def name
    object.display_name
  end

  def avatar
    Avatar.new(object).url
  end
end
