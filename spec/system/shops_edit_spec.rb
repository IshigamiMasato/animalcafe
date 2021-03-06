require 'rails_helper'

RSpec.describe "ShopsEdit", type: :system do
  let(:user) { FactoryBot.create(:user) }
  let!(:shop) { FactoryBot.create(:shop, user: user) }
  let(:tag1) { FactoryBot.create(:tag, name: "犬", tag_type: "animal") }
  let(:tag2) { FactoryBot.create(:tag, name: "柴犬", tag_type: "animal") }
  let(:tag3) { FactoryBot.create(:tag, name: "wifiあり", tag_type: "env") }
  let(:tag4) { FactoryBot.create(:tag, name: "コンセントあり", tag_type: "env") }
  let!(:tag_map1) { FactoryBot.create(:tag_map, shop: shop, tag: tag1) }
  let!(:tag_map2) { FactoryBot.create(:tag_map, shop: shop, tag: tag2) }
  let!(:tag_map3) { FactoryBot.create(:tag_map, shop: shop, tag: tag3) }
  let!(:tag_map4) { FactoryBot.create(:tag_map, shop: shop, tag: tag4) }

  it "投稿した店舗を編集する" do
    # ログインする前
    visit user_path(user)
    expect(current_path).to eq user_path(user)

    expect(page).to_not have_selector(".edit_icon")

    # ログインした後
    log_in_as(user)
    expect(current_path).to eq shops_path

    expect(page).to have_selector(".edit_icon")
    find(".edit_icon").click
    expect(current_path).to eq edit_shop_path(shop)

    # 無効な編集情報を入力する
    fill_in "店名", with: "a" * 51
    fill_in "開店時間", with: ""
    fill_in "閉店時間", with: ""
    fill_in "定休日", with: ""
    fill_in "電話番号", with: ""
    fill_in "住所", with: ""
    fill_in "最寄り駅", with: ""
    fill_in "予算(下)", with: ""
    fill_in "予算(上)", with: ""
    fill_in "店舗紹介", with: "a" * 301
    click_button "Save changes"

    expect(page).to have_selector "div#error_explanation"
    expect(page).to have_css "div.field_with_errors"

    # 有効な編集情報を入力する
    fill_in "店名", with: "a" * 50
    fill_in "開店時間", with: "10:00"
    fill_in "閉店時間", with: "20:00"
    fill_in "定休日", with: "不定休"
    fill_in "電話番号", with: "123-456"
    fill_in "住所", with: "東京都江東区豊洲２丁目２"
    fill_in "最寄り駅", with: "豊洲駅"
    fill_in "予算(下)", with: "500"
    fill_in "予算(上)", with: "1500"
    fill_in "動物の種類", with: "柴犬 ゴールデンレトリバー"
    fill_in "設備", with: "クレジット可"
    fill_in "店舗紹介", with: "a" * 300
    click_button "Save changes"

    expect(page).to have_selector "div.alert-success"
    expect(current_path).to eq shop_path(shop)

    shop.reload
    expect(shop.name).to eq "a" * 50
    expect(shop.started_at).to eq "Sat, 01 Jan 2000 10:00:00.000000000 JST +09:00"
    expect(shop.closed_at).to eq "Sat, 01 Jan 2000 20:00:00.000000000 JST +09:00"
    expect(shop.regular_holiday).to eq "不定休"
    expect(shop.phone_number).to eq "123-456"
    expect(shop.address).to eq "東京都江東区豊洲２丁目２"
    expect(shop.nearest_station).to eq "豊洲駅"
    expect(shop.low_budget).to eq 500
    expect(shop.high_budget).to eq 1500
    expect(shop.description).to eq "a" * 300
    expect(shop.tags.count).to eq 3
    expect(shop.tags.where(tag_type: "animal").pluck(:name)).to eq ["柴犬", "ゴールデンレトリバー"]
    expect(shop.tags.where(tag_type: "env").pluck(:name)).to eq ["クレジット可"]
  end
end
