FactoryBot.define do
  factory :user do
    name { "Test User" }
    email { "user@test.com" }
    password { "foobar" }
    password_confirmation { "foobar" }
  end
end
