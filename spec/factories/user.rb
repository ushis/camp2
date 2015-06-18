FactoryGirl.define do
  factory :user do
    email { "#{SecureRandom.hex(4)}@#{SecureRandom.hex(4)}.com" }
    name { SecureRandom.hex(4) }
    password { SecureRandom.hex(8) }
    password_confirmation { password }
  end
end
