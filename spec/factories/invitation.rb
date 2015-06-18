FactoryGirl.define do
  factory :invitation do
    topic
    email { "#{SecureRandom.hex(4)}@#{SecureRandom.hex(4)}.com" }
  end
end
