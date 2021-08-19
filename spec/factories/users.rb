FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "Test User#{n}" }
    sequence(:email) { |n| "user#{n}@test.com" }
    password { "foobar" }
    password_confirmation { "foobar" }
    activated { true }
    activated_at { Time.zone.now }

    trait :no_activated do
      activated { false }
      activated_at { nil }
    end

    trait :admin do
      admin { true }
    end
  end

  factory :invalid_user, class: "User" do
    name { "" }
    email { "user@invalid" }
    password { "foo" }
    password_confirmation { "bar" }
  end
end
