require 'rails_helper'

RSpec.describe "PostShops", type: :system do
  let!(:user) { FactoryBot.create(:user) }

  it "店舗を投稿する" do
    # ログイン前
    visit root_path
    expect(current_path).to eq root_path
    expect(page).to_not have_link href: new_shop_path

    # ログイン後
    log_in_as(user)
    expect(current_path).to eq user_path(user)
    within ".navbar-nav" do # ログインしていることを確認
      expect(page).to_not have_link "Log in"
      expect(page).to have_link "Log out"
      expect(page).to have_link href: user_path(user)
    end
    expect(page).to have_link href: new_shop_path, count: 2

    # 無効な情報で登録する
    find(".post_shop_icon").click
    expect(current_path).to eq new_shop_path

    expect {
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
      attach_file("shop_images", [
        "#{Rails.root}/spec/fixtures/10MB.png",
        "#{Rails.root}/spec/fixtures/test.jpg",
        "#{Rails.root}/spec/fixtures/test2.jpeg",
        "#{Rails.root}/spec/fixtures/test3.jpeg",
        "#{Rails.root}/spec/fixtures/test4.jpeg",
      ])
      click_button "Post shop"
    }.to_not change(Shop, :count)

    expect(page).to have_selector "div#error_explanation"
    expect(page).to have_css "div.field_with_errors"
    expect(page).to have_selector "li", text: "店名は50文字以内で入力してください"
    expect(page).to have_selector "li", text: "開店時間を入力してください"
    expect(page).to have_selector "li", text: "閉店時間を入力してください"
    expect(page).to have_selector "li", text: "定休日を入力してください"
    expect(page).to have_selector "li", text: "住所を入力してください"
    expect(page).to have_selector "li", text: "最寄り駅を入力してください"
    expect(page).to have_selector "li", text: "予算(下)を入力してください"
    expect(page).to have_selector "li", text: "店舗紹介は300文字以内で入力してください"
    expect(page).to have_selector "li", text: "画像は5MB未満のファイルを選択してください"
    expect(page).to have_selector "li", text: "画像は最大4枚までです"

    # 有効な情報で登録する
    expect {
      fill_in "店名", with: "a" * 30
      fill_in "開店時間", with: "9:00"
      fill_in "閉店時間", with: "19:00"
      fill_in "定休日", with: "月曜日"
      fill_in "電話番号", with: "123-456-789"
      fill_in "住所", with: "新宿区西新宿2-8-1"
      fill_in "最寄り駅", with: "新宿駅"
      fill_in "予算(下)", with: 1000
      fill_in "予算(上)", with: 2000
      fill_in "店舗紹介", with: "a" * 300
      attach_file("shop_images", "#{Rails.root}/spec/fixtures/test.jpg")
      click_button "Post shop"
    }.to change(Shop, :count).by(1)

    shop = Shop.last
    expect(current_path).to eq shop_path(shop)
    expect(page).to have_selector "div.alert-success"
  end
end