class InvitationSerializer < ApplicationSerializer
  attributes :code, :status
  belongs_to :member
end
