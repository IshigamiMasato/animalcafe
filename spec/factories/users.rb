FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "Test User#{n}" }
    sequence(:email) { |n| "user#{n}@test.com" }
    password { "foobar" }
    password_confirmation { "foobar" }
  end

  factory :admin_user, class: "User" do
    name { "admin_user" }
    email { "user@admin.com" }
    password { "foobar" }
    password_confirmation { "foobar" }
    admin { true }
  end
end
