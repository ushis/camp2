class List < ActiveRecord::Base
  include ActsAsList

  belongs_to :topic, inverse_of: :lists

  has_many :items, dependent: :destroy, inverse_of: :list
  has_many :users, through: :topic

  acts_as_list_of :items

  validates :topic, presence: true
  validates :name,  presence: true, length: {maximum: 255}
end
