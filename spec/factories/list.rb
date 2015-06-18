FactoryGirl.define do
  factory :list do
    topic
    name { SecureRandom.hex(8) }
  end
end
