require 'rails_helper'

RSpec.describe "SearchShops", type: :system do
  let!(:tokyo_area_shop) { FactoryBot.create(:shop, user: user) }
  let!(:tokyo_area_shop2) { FactoryBot.create(:shop, address: "東京都墨田区押上１丁目１−２", user: user) }
  let!(:tokyo_area_shop3) { FactoryBot.create(:shop, address: "東京都豊島区目白３丁目", user: user) }
  let!(:tokyo_area_shop4) { FactoryBot.create(:shop, address: "東京都世田谷区北沢２丁目２４−２", user: user) }
  let!(:tokyo_area_shop5) { FactoryBot.create(:shop, address: "東京都新宿区百人町１丁目", user: user) }
  let!(:tokyo_area_shop6) { FactoryBot.create(:shop, address: "東京都渋谷区神宮前１丁目", user: user) }
  let!(:tokyo_area_shop7) { FactoryBot.create(:shop, address: "東京都渋谷区神宮前2丁目", user: user) }
  let!(:kanagawa_area_shop) { FactoryBot.create(:other_shop, user: user) }
  let(:user) { FactoryBot.create(:user) }

  it "店舗をエリアで検索する" do
    visit root_path
    expect(current_path).to eq root_path

    # 空文字で検索する
    fill_in "search_address", with: ""
    click_button "検索"
    expect(current_path).to eq shops_path
    expect(page).to have_title "Search shops | ANIMAL CAFE"
    expect(page).to have_content "検索結果: 8件"

    # 登録していない住所で検索
    fill_in "search_address", with: "北海道"
    click_button "検索"
    expect(current_path).to eq shops_path
    expect(page).to have_content "検索結果: 0件"

    # 東京で検索
    fill_in "search_address", with: "東京"
    click_button "検索"
    expect(current_path).to eq shops_path
    expect(page).to have_content "検索結果: 7件"
    expect(page).to have_css "div.pagination"
    # 新しく作成された店舗の投稿が検索上位に来る
    expect(page).to_not have_link tokyo_area_shop.name
    expect(page).to have_link tokyo_area_shop2.name
    expect(page).to have_link tokyo_area_shop3.name
    expect(page).to have_link tokyo_area_shop4.name
    expect(page).to have_link tokyo_area_shop5.name
    expect(page).to have_link tokyo_area_shop6.name
    expect(page).to have_link tokyo_area_shop7.name

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

    # profileページの過去の投稿の部分にpaginateがある
    log_in_as(user)
    expect(current_path).to eq shops_path
    find(".user_icon").click
    expect(current_path).to eq user_path(user)
    expect(page).to have_content "過去の投稿: 8件"
    expect(page).to have_css "div.pagination"
    # 新しく作成された店舗の投稿が検索上位に来る
    expect(page).to_not have_link tokyo_area_shop.name
    expect(page).to_not have_link tokyo_area_shop2.name
    expect(page).to have_link tokyo_area_shop3.name
    expect(page).to have_link tokyo_area_shop4.name
    expect(page).to have_link tokyo_area_shop5.name
    expect(page).to have_link tokyo_area_shop6.name
    expect(page).to have_link tokyo_area_shop7.name
    expect(page).to have_link kanagawa_area_shop.name
  end
end
