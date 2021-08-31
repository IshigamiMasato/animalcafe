require 'rails_helper'

RSpec.describe "BookmarkShops", type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  let!(:shop) { FactoryBot.create(:shop, user: other_user) }

  it "ブックマークする" do
    # ログインしない
    visit root_path
    expect(current_path).to eq root_path
    fill_in "search_address", with: "東京"
    click_button "検索"
    expect(current_path).to eq shops_path
    click_link href: shop_path(shop), match: :first
    expect(current_path).to eq shop_path(shop)
    expect(page).to_not have_selector "div#bookmark_form"

    # ログインする
    log_in_as(user)
    fill_in "search_address", with: "東京"
    click_button "検索"
    expect(current_path).to eq shops_path
    click_link href: shop_path(shop), match: :first
    expect(page).to have_selector "div#bookmark_form"
    # ブックマークボタンを押して登録する
    expect {
      find(".bookmark_btn").click
    }.to change(Bookmark, :count).by(1)
    # ブックマークボタンを押して、ブックマークを削除する
    expect {
      find(".bookmark_btn").click
    }.to change(Bookmark, :count).by(-1)
  end
end
