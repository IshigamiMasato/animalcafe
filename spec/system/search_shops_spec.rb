require 'rails_helper'

RSpec.describe "SearchShops", type: :system do
  let!(:tokyo_area_shop) { FactoryBot.create(:shop, user: user) }
  let!(:tokyo_area_shop2) { FactoryBot.create(:shop, address: "東京都墨田区押上１丁目１−２", user: user) }
  let!(:kanagawa_area_shop) { FactoryBot.create(:other_shop, user: user) }
  let(:user) { FactoryBot.create(:user) }

  it "店舗をエリアで検索する" do
    visit root_path
    expect(current_path).to eq root_path

    # 空文字で検索
    fill_in "search_address", with: ""
    click_button "検索"
    expect(current_path).to eq shops_path
    expect(page).to have_title "Search shops | ANIMAL CAFE"
    expect(page).to have_content "検索結果: 0件"

    # 登録していない住所で検索
    fill_in "search_address", with: "北海道"
    click_button "検索"
    expect(current_path).to eq shops_path
    expect(page).to have_content "検索結果: 0件"

    # 東京で検索
    fill_in "search_address", with: "東京"
    click_button "検索"
    expect(current_path).to eq shops_path
    expect(page).to have_content "検索結果: 2件"
    expect(page).to have_link tokyo_area_shop.name
    expect(page).to have_link tokyo_area_shop2.name

    # 東京都新宿区西新宿2-8-1で検索
    fill_in "search_address", with: "東京都新宿区西新宿2-8-1"
    click_button "検索"
    expect(current_path).to eq shops_path
    expect(page).to have_content "検索結果: 1件"
    expect(page).to have_link tokyo_area_shop.name

    # 神奈川で検索
    fill_in "search_address", with: "神奈川"
    click_button "検索"
    expect(current_path).to eq shops_path
    expect(page).to have_content "検索結果: 1件"
    expect(page).to have_link kanagawa_area_shop.name
  end
end
