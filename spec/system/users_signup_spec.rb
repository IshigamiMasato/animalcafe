require 'rails_helper'

RSpec.describe "UsersSignup", type: :system do
  before do
    visit root_path
    click_link "Sign up now!"
  end

  context "有効な登録情報を入力した場合" do
    scenario "ユーザーが登録されプロフィールページにリダイレクトする" do
      expect {
        fill_in "名前", with: "Example User"
        fill_in "メールアドレス", with: "user@example.com"
        fill_in "パスワード", with: "password"
        fill_in "パスワード(確認)", with: "password"
        click_button "登録する"
      }.to change(User, :count).by(1)

      expect(current_path).to eq user_path(User.last)
      expect(page).to have_selector "div.alert-success" # flashの成功メッセージが表示されていることを確認
    end

    scenario "プロフィール画像を登録できる" do
      expect {
        fill_in "名前", with: "Example User"
        fill_in "メールアドレス", with: "user@example.com"
        attach_file("user_avater", "#{Rails.root}/spec/fixtures/test.jpg")
        fill_in "パスワード", with: "password"
        fill_in "パスワード(確認)", with: "password"
        click_button "登録する"
      }.to change(User, :count).by(1)

      expect(current_path).to eq user_path(User.last)
      expect(page).to have_selector "div.alert-success"
      expect(User.last.avater.attached?).to eq true # 画像がモデルに結びついていることを確認
      expect(page).to have_selector "img[src$='test.jpg']" # 画面上で$=以降の文字列を含むimg要素があることを確認
    end
  end

  context "無効な登録情報を入力した場合" do
    scenario "ユーザー登録はされない" do
      expect {
        fill_in "名前", with: ""
        fill_in "メールアドレス", with: "user@invalid"
        fill_in "パスワード", with: "foo"
        fill_in "パスワード(確認)", with: "bar"
        click_button "登録する"
      }.to_not change(User, :count)

      expect(page).to have_selector "#error_explanation" # _error_messages.html.erbが描画されていることの確認
      expect(page).to have_css ".field_with_errors" # 無効内容の送信により元のぺーじに戻ったら、railsはエラー箇所を.field_with_errorsクラスのdivタグで囲む
      expect(page).to have_selector "li", text: "Name can't be blank"
      expect(page).to have_selector "li", text: "Email is invalid"
      expect(page).to have_selector "li", text: "Password confirmation doesn't match Password"
      expect(page).to have_selector "li", text: "Password is too short (minimum is 6 characters)"
    end

    scenario "5MB以上の画像はプロフィール画像として登録できない" do
      expect {
        fill_in "名前", with: "Example User"
        fill_in "メールアドレス", with: "user@example.com"
        attach_file("user_avater", "#{Rails.root}/spec/fixtures/10MB.png") # 5MB以上のファイル画像を添付
        fill_in "パスワード", with: "password"
        fill_in "パスワード(確認)", with: "password"
        click_button "登録する"
      }.to_not change(User, :count)

      expect(page).to have_selector "#error_explanation"
      expect(page).to have_css ".field_with_errors"
      expect(page).to have_selector "li", text: "Avater should be less than 5MB"
    end

    scenario "無効なファイル形式はプロフィール画像として登録できない" do
      expect {
        fill_in "名前", with: "Example User"
        fill_in "メールアドレス", with: "user@example.com"
        attach_file("user_avater", "#{Rails.root}/spec/fixtures/test.html") # 無効なファイル形式を添付
        fill_in "パスワード", with: "password"
        fill_in "パスワード(確認)", with: "password"
        click_button "登録する"
      }.to_not change(User, :count)

      expect(page).to have_selector "#error_explanation"
      expect(page).to have_css ".field_with_errors"
      expect(page).to have_selector "li", text: "Avater must be a valid image format"
    end
  end
end
