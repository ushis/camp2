class User < ActiveRecord::Base
  include HasToken

  has_token :access, 1.week

  has_secure_password validations: false

  has_many :comments, dependent: :nullify, inverse_of: :user
  has_many :shares,   dependent: :destroy, inverse_of: :user
  has_many :topics,   through: :shares
  has_many :lists,    through: :topics
  has_many :items,    through: :lists

  validates :name,  presence: true, length: {maximum: 255}

  validates :email, presence: true, length: {maximum: 255},
    uniqueness: true, format: /.+@.+/

  validates :password, presence: true,
    if: -> (u) { u.password_digest.blank? }

  validates :password, confirmation: true

  validates :password_confirmation, presence: true,
    if: -> (u) { u.password.present? }

  # Returns the users email with name. Suitable for mail headers.
  def email_with_name
    "#{name} <#{email}>"
  end
end
