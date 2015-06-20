FactoryGirl.define do
  factory :item do
    list
    name { SecureRandom.hex(8) }
    closed { [true, false].sample }
  end
end
