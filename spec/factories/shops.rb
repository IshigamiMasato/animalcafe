FactoryBot.define do
  factory :shop do
    name { "Test Shop" }
    started_at { "9:00" }
    closed_at { "19:00" }
    regular_holiday { "月曜日" }
    phone_number { "123-456-789" }
    address { "新宿区西新宿2-8-1" }
    nearest_station { "新宿駅" }
    low_budget { "1000" }
    high_budget { "2000" }
    description { "テストです" }
    created_at { 10.minutes.ago }
    user { "" }

    trait :two_years_ago do
      name { "one year ago Post" }
      address { "東京都千代田区丸の内１丁目" }
      created_at { 2.years.ago }
    end

    trait :yesterday do
      name { "yesterday Post" }
      address { "東京都千代田区有楽町１丁目" }
      created_at { 1.day.ago }
    end

    trait :most_recent_post do
      name { "most recent Post" }
      address { "東京都千代田区丸の内３丁目５−１" }
      created_at { Time.zone.now }
    end
  end

  factory :invalid_shop, class: "User" do
    name { "a" * 51 }
    started_at { "" }
    closed_at { "" }
    regular_holiday { "" }
    phone_number { "" }
    address { "" }
    low_budget { "" }
    high_budget { "" }
    description { "" }
    nearest_station { "a" * 31 }
    user { "" }
  end
end
