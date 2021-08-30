require 'rails_helper'

RSpec.describe Shop, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let!(:shop) { FactoryBot.build(:shop, user: user) }

  it "店名、開店時間、閉店時間、定休日、住所、最寄り駅、最低予算、店舗紹介、user_idがあれば有効である" do
    expect(shop).to be_valid
  end

  it "user_idがなければ無効である" do
    shop.user_id = ""
    expect(shop).to_not be_valid
  end

  it "店名がなければ無効である" do
    shop.name = ""
    shop.valid?
    expect(shop.errors[:name]).to include("を入力してください")
  end

  it "店名の長さが51文字以上は無効な状態である" do
    shop.name = "a" * 51
    shop.valid?
    expect(shop.errors[:name]).to include("は50文字以内で入力してください")
  end

  it "開店時間がなければ無効である" do
    shop.started_at = ""
    shop.valid?
    expect(shop.errors[:started_at]).to include("を入力してください")
  end

  it "閉店時間がなければ無効である" do
    shop.closed_at = ""
    shop.valid?
    expect(shop.errors[:closed_at]).to include("を入力してください")
  end

  it "定休日がなければ無効である" do
    shop.regular_holiday = ""
    shop.valid?
    expect(shop.errors[:regular_holiday]).to include("を入力してください")
  end

  it "住所がなければ無効である" do
    shop.address = ""
    shop.valid?
    expect(shop.errors[:address]).to include("を入力してください")
  end

  it "最寄り駅がなければ無効である" do
    shop.nearest_station = ""
    shop.valid?
    expect(shop.errors[:nearest_station]).to include("を入力してください")
  end

  it "最寄り駅の長さが31文字以上は無効な状態である" do
    shop.nearest_station = "a" * 31
    shop.valid?
    expect(shop.errors[:nearest_station]).to include("は30文字以内で入力してください")
  end

  it "最低予算がなければ無効である" do
    shop.low_budget = ""
    shop.valid?
    expect(shop.errors[:low_budget]).to include("を入力してください")
  end

  it "店舗紹介がなければ無効である" do
    shop.description = ""
    shop.valid?
    expect(shop.errors[:description]).to include("を入力してください")
  end

  it "店舗紹介の長さが301文字以上は無効な状態である" do
    shop.description = "a" * 301
    shop.valid?
    expect(shop.errors[:description]).to include("は300文字以内で入力してください")
  end

  it "重複した店名は無効である" do
    shop.save
    duplicate_name_shop = FactoryBot.build(:shop, name: shop.name, address: "東京都新宿区新宿３丁目３８−１", user: user)
    duplicate_name_shop.save
    expect(duplicate_name_shop.errors[:name]).to include("はすでに存在します")
  end

  it "重複した住所は無効である" do
    shop.save
    duplicate_address_shop = FactoryBot.build(:shop, name: "Other shop", user: user)
    duplicate_address_shop.save
    expect(duplicate_address_shop.errors[:address]).to include("はすでに存在します")
  end

  it "ユーザーが削除されたら、そのユーザーに紐づく店の投稿は削除される" do
    shop.save
    expect {
      user.destroy
    }.to change(Shop, :count).by(-1)
  end

  describe "投稿順のテスト" do
    let!(:a_few_minutes_ago_post) { FactoryBot.create(:shop, name: "10minutes ago Post", user: user) }
    let!(:two_years_ago_post) { FactoryBot.create(:shop, :two_years_ago, user: user) }
    let!(:yesterday_post) { FactoryBot.create(:shop, :yesterday, user: user) }
    let!(:most_recent_post) { FactoryBot.create(:shop, :most_recent_post, user: user) }

    it "投稿順に並べた時の一番上の投稿は、一番最近の投稿である" do
      expect(Shop.first).to eq most_recent_post
    end
  end
end
