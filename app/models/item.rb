class Item < ActiveRecord::Base
  belongs_to :list, inverse_of: :items, counter_cache: true

  has_many :comments, dependent: :destroy, inverse_of: :item
  has_many :users,    through: :list

  validates :list, presence: true
  validates :name, presence: true, length: {maximum: 255}

  validate(on: :update) do
    errors.add(:base, 'Item cannot be moved among topics.') if topic_changed?
  end

  private

  # Returns true if the topic has changed else false
  def topic_changed?
    list_id_changed? && list(true).try(:topic) != topic_was
  end

  # Returns the previous topic
  def topic_was
    List.find_by(id: list_id_was).try(:topic)
  end
end
