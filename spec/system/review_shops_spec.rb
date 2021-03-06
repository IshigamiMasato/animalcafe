require 'rails_helper'

RSpec.describe "ReviewShops", type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  let(:reviewer) { FactoryBot.create(:user) }
  let(:shop) { FactoryBot.create(:shop, user: other_user) }
  let!(:review1) { FactoryBot.create(:review, content: "1つめのクチコミ", user: reviewer, shop: shop) }
  let!(:review2) { FactoryBot.create(:review, content: "2つめのクチコミ", user: reviewer, shop: shop) }
  let!(:review3) { FactoryBot.create(:review, content: "3つめのクチコミ", user: reviewer, shop: shop) }

  it "店舗にクチコミをする" do
    # ログイン前
    visit shop_path(shop)
    expect(current_path).to eq shop_path(shop)
    click_button "送信"
    expect(current_path).to eq login_path
    expect(page).to have_selector "div.alert-danger"

    # ログインする
    log_in_as(user)
    within ".navbar-right" do # ログインしていることを確認
      expect(page).to_not have_link "ログイン"
      expect(page).to have_link "ログアウト"
      expect(page).to have_link href: user_path(user)
    end
    visit shop_path(shop)
    expect(current_path).to eq shop_path(shop)

    # ３軒目まではもっと見るリンクは表示しない
    expect(page).to_not have_link "もっと見る..."

    # 無効な送信をする
    expect {
      fill_in "review_content", with: "a" * 256
      click_button "送信"
    }.to_not change(Review, :count)
    expect(page).to have_selector "div#error_explanation"
    expect(page).to have_css "div.field_with_errors"
    expect(page).to have_selector "li", text: "点数を入力してください"
    expect(page).to have_selector "li", text: "コメントは255文字以内で入力してください"

    # 有効な送信
    expect {
      find("#rating_value", visible: false).set("5")
      fill_in "review_content", with: "a" * 255
      click_button "送信"
    }.to change(Review, :count).by(1)
    expect(page).to have_content "a" * 255

    # 4件目からもっと見るリンクを表示する
    expect(page).to have_link "もっと見る..."

    # クチコミを削除する
    expect(page).to have_link "削除"
    expect {
      click_link "削除"
    }.to change(Review, :count).by(-1)
    expect(page).to_not have_content "a" * 255
  end

  context "レビューワーではないユーザーでログインした場合" do
    let!(:review) { FactoryBot.create(:review, user: user, shop: shop) }

    it "レビューの削除リンクを表示しない" do
      log_in_as(other_user)
      within ".navbar-right" do # ログインしていることを確認
        expect(page).to_not have_link "ログイン"
        expect(page).to have_link "ログアウト"
        expect(page).to have_link href: user_path(other_user)
      end
      visit shop_path(shop)
      expect(current_path).to eq shop_path(shop)
      expect(page).to have_content review.content
      expect(page).to_not have_link "削除"
    end
  end
end
