class AcceptionSerializer < ApplicationSerializer
  attributes :id, :created_at, :updated_at

  has_one :topic
end
