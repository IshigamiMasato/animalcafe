require 'rails_helper'

RSpec.describe "LikeShops", type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  let!(:shop) { FactoryBot.create(:shop, user: other_user) }

  it "いいねする" do
    # ログインしない
    visit root_path
    expect(current_path).to eq root_path
    fill_in "search_address", with: "東京"
    click_button "検索"
    expect(current_path).to eq shops_path
    click_link href: shop_path(shop), match: :first
    expect(current_path).to eq shop_path(shop)
    expect(page).to_not have_selector("div#like_form")

    # ログインする
    log_in_as(user)
    fill_in "search_address", with: "東京"
    click_button "検索"
    expect(current_path).to eq shops_path
    click_link href: shop_path(shop), match: :first
    expect(current_path).to eq shop_path(shop)
    expect(page).to have_selector("div#like_form")

    # いいねボタンを押していいねする
    expect {
      find(".like_btn").click
    }.to change(Like, :count).by(1)

    # いいねボタンを押していいねを解除する
    expect {
      find(".like_btn").click
    }.to change(Like, :count).by(-1)
  end
end
