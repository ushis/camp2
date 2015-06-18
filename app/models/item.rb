class Item < ActiveRecord::Base
  belongs_to :list, inverse_of: :items

  has_many :comments, dependent: :destroy, inverse_of: :item
  has_many :users,    through: :list

  validates :list, presence: true
  validates :name, presence: true, length: {maximum: 255}
end
