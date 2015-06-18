class Share < ActiveRecord::Base
  attr_accessor :invitation

  belongs_to :user,   inverse_of: :shares
  belongs_to :topic,  inverse_of: :shares, counter_cache: true

  validates :user,    presence: true
  validates :topic,   presence: true
  validates :user_id, uniqueness: {scope: :topic_id}

  after_create { invitation.try(:destroy) && clear_association_cache }

  after_commit(on: :destroy) { topic.destroy if topic.dangling? }
end
