FactoryBot.define do
  factory :review do
    user { nil }
    shop { nil }
    content { "MyString" }
    score { 1 }
    created_at { 10.minutes.ago }

    trait :most_recent_review do
      created_at { Time.zone.now }
    end

    trait :yesterday do
      created_at { 1.day.ago }
    end
  end
end
