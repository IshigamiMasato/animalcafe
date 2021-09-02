require 'rails_helper'

RSpec.describe "ReviewShops", type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  let(:shop) { FactoryBot.create(:shop, user: other_user) }

  it "店舗にクチコミをする" do
    # ログイン前
    visit shop_path(shop)
    expect(current_path).to eq shop_path(shop)
    click_button "クチコミする"
    expect(current_path).to eq login_path
    expect(page).to have_selector "div.alert-danger"

    # ログインする
    log_in_as(user)
    visit shop_path(shop)
    expect(current_path).to eq shop_path(shop)

    # 無効な送信をする
    expect {
      fill_in "review_content", with: "a" * 256
      click_button "クチコミする"
    }.to_not change(Review, :count)
    expect(page).to have_selector "div#error_explanation"
    expect(page).to have_css "div.field_with_errors"
    expect(page).to have_selector "li", text: "点数を入力してください"
    expect(page).to have_selector "li", text: "コメントは255文字以内で入力してください"

    # 有効な送信
    expect {
      find("#rating_value", visible: false).set("5")
      fill_in "review_content", with: "a" * 255
      click_button "クチコミする"
    }.to change(Review, :count).by(1)
    expect(page).to have_content user.name
    expect(page).to have_content "a" * 255
  end
end
