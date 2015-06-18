class InvitationSerializer < ApplicationSerializer
  attributes :id, :email, :expired, :created_at, :updated_at

  def expired
    object.expired?
  end
end
