require 'rails_helper'

RSpec.describe "BookmarkDisplay", type: :system do
  let(:other_user) { FactoryBot.create(:user) }
  let!(:shop) { FactoryBot.create(:shop, user: other_user) }
  let!(:shop2) { FactoryBot.create(:shop, address: "東京都墨田区押上１丁目１−２", user: other_user) }
  let!(:shop3) { FactoryBot.create(:shop, address: "東京都豊島区目白３丁目", user: other_user) }
  let!(:shop4) { FactoryBot.create(:shop, address: "東京都世田谷区北沢２丁目２４−２", user: other_user) }
  let!(:shop5) { FactoryBot.create(:shop, address: "東京都新宿区百人町１丁目", user: other_user) }
  let!(:shop6) { FactoryBot.create(:shop, address: "東京都渋谷区神宮前１丁目", user: other_user) }
  let!(:shop7) { FactoryBot.create(:shop, address: "東京都渋谷区代々木１丁目３４", user: other_user) }

  let(:user) { FactoryBot.create(:user) }
  let!(:bookmark) { FactoryBot.create(:bookmark, user: user, shop: shop) }
  let!(:bookmark2) { FactoryBot.create(:bookmark, user: user, shop: shop2) }
  let!(:bookmark3) { FactoryBot.create(:bookmark, user: user, shop: shop3) }
  let!(:bookmark4) { FactoryBot.create(:bookmark, user: user, shop: shop4) }
  let!(:bookmark5) { FactoryBot.create(:bookmark, user: user, shop: shop5) }
  let!(:bookmark6) { FactoryBot.create(:bookmark, user: user, shop: shop6) }
  let!(:bookmark7) { FactoryBot.create(:bookmark, user: user, shop: shop7) }

  it "ブックマークのpaginateのテスト" do
    log_in_as(user)
    expect(current_path).to eq user_path(user)
    click_link "ブックマーク"
    expect(current_path).to eq bookmarking_user_path(user)
    expect(page).to have_content "ブックマーク: 7件"
    expect(page).to have_css "div.pagination"
    expect(page).to_not have_link bookmark.shop.name
    expect(page).to_not have_link bookmark2.shop.name
    expect(page).to have_link bookmark3.shop.name
    expect(page).to have_link bookmark4.shop.name
    expect(page).to have_link bookmark5.shop.name
    expect(page).to have_link bookmark6.shop.name
    expect(page).to have_link bookmark6.shop.name
    expect(page).to have_link bookmark7.shop.name
  end
end
