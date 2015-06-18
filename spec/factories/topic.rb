FactoryGirl.define do
  factory :topic do
    name { SecureRandom.hex(8) }
  end
end
