class Comment < ActiveRecord::Base
  belongs_to :user, inverse_of: :comments
  belongs_to :item, inverse_of: :comments

  validates :item,    presence: true
  validates :comment, presence: true
end
