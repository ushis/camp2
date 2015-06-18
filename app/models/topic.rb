class Topic < ActiveRecord::Base
  include ActsAsList

  has_many :lists,        dependent: :destroy, inverse_of: :topic
  has_many :invitations,  dependent: :destroy, inverse_of: :topic
  has_many :shares,       dependent: :destroy, inverse_of: :topic
  has_many :users,        through: :shares

  acts_as_list_of :lists

  validates :name, presence: true, length: {maximum: 255}

  # Returns true if the topic is not reachable by any user, else false
  def dangling?
    shares.count < 1 && invitations.active.count < 1
  end
end
