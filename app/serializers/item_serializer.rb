class ItemSerializer < ApplicationSerializer
  attributes :id, :name, :closed, :comments_count, :created_at, :updated_at
end
