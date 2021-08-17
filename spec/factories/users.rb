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

    trait :add_image_avater do
      avater { Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/test.jpg") }
    end
  end

  factory :admin_user, class: "User" do
    name { "admin_user" }
    email { "user@admin.com" }
    password { "foobar" }
    password_confirmation { "foobar" }
    admin { true }
    activated { true }
    activated_at { Time.zone.now }
  end
end
