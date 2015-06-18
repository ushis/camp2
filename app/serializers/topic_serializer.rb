class TopicSerializer < ApplicationSerializer
  attributes :id,
    :name,
    :shares_count,
    :invitations_count,
    :lists_count,
    :created_at,
    :updated_at
end
