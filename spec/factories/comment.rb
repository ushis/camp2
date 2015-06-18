FactoryGirl.define do
  factory :comment do
    user
    item
    comment { SecureRandom.hex(32) }
  end
end
