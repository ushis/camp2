class Invitation < ActiveRecord::Base
  include HasToken

  TTL = 4.weeks

  has_token :invitation, 4.weeks

  belongs_to :topic, inverse_of: :invitations, counter_cache: true

  validates :topic, presence: true

  validates :email, presence: true, length: {maximum: 255},
    uniqueness: {scope: :topic_id}, format: /.+@.+/

  scope :active, -> { where('created_at >= ?', TTL.ago) }

  scope :expired, -> { where('created_at < ?', TTL.ago) }

  after_commit(on: :destroy) { topic.destroy if topic.dangling? }

  # Returns true if the invitation is not yet expired, else false
  def active?
    created_at >= TTL.ago
  end

  # Returns true if the invitation is already expired, else false
  def expired?
    !active?
  end

  # Builds a share for the given user
  def build_share_for(user)
    topic.shares.build(user: user, invitation: self)
  end
end
