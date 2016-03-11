class InvitationSerializer < ActiveModel::Serializer
  attributes :code, :status
  belongs_to :member
end
