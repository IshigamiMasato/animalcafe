require 'rails_helper'

RSpec.describe "UsersSignup", type: :system do
  before do
    visit root_path
    click_link "Sign up now!"
  end

  context "有効な登録情報を入力した場合" do
    it "ユーザーを作成し、rootページにリダイレクトする" do
      expect {
        fill_in "名前", with: "Example User"
        fill_in "メールアドレス", with: "user@example.com"
        fill_in "パスワード", with: "foobar"
        fill_in "パスワード(確認)", with: "foobar"
        click_button "Create my account"
      }.to change(User, :count).by(1)

      user = User.last

      expect(current_path).to eq root_path
      expect(page).to have_selector "div.alert-info"

      within ".navbar-nav" do # ログインしていないことを確認
        expect(page).to have_link "Log in"
        expect(page).to_not have_link "Log out"
        expect(page).to_not have_link href: user_path(user)
      end
    end

    it "プロフィール画像を登録する" do
      expect {
        fill_in "名前", with: "Example User"
        fill_in "メールアドレス", with: "user@example.com"
        attach_file "user_avater", "#{Rails.root}/spec/fixtures/test.jpg"
        fill_in "パスワード", with: "foobar"
        fill_in "パスワード(確認)", with: "foobar"
        click_button "Create my account"
      }.to change(User, :count).by(1)

      user = User.last

      expect(current_path).to eq root_path
      expect(page).to have_selector "div.alert-info"
      expect(user.avater.attached?).to eq true # 画像がモデルに結びついていることを確認

      within ".navbar-nav" do # ログインしていないことを確認
        expect(page).to have_link "Log in"
        expect(page).to_not have_link "Log out"
        expect(page).to_not have_link href: user_path(user)
      end
    end
  end

  context "無効な登録情報を入力した場合" do
    it "ユーザーを作成しない" do
      expect {
        fill_in "名前", with: ""
        fill_in "メールアドレス", with: "user@invalid"
        fill_in "パスワード", with: "foo"
        fill_in "パスワード(確認)", with: "bar"
        click_button "Create my account"
      }.to_not change(User, :count)

      expect(page).to have_selector "div#error_explanation"
      expect(page).to have_css "div.field_with_errors" # 無効内容の送信により元のぺーじに戻ったら、railsはエラー箇所を.field_with_errorsクラスのdivタグで囲む
      expect(page).to have_selector "li", text: "名前を入力してください"
      expect(page).to have_selector "li", text: "メールアドレスは不正な値です"
      expect(page).to have_selector "li", text: "パスワード(確認)とパスワードの入力が一致しません"
      expect(page).to have_selector "li", text: "パスワードは6文字以上で入力してください"
    end

    it "5MB以上の画像はプロフィール画像として登録しない" do
      expect {
        fill_in "名前", with: "Example User"
        fill_in "メールアドレス", with: "user@example.com"
        attach_file("user_avater", "#{Rails.root}/spec/fixtures/10MB.png") # 5MB以上のファイル画像を添付
        fill_in "パスワード", with: "password"
        fill_in "パスワード(確認)", with: "password"
        click_button "Create my account"
      }.to_not change(User, :count)

      expect(page).to have_selector "div#error_explanation"
      expect(page).to have_css "div.field_with_errors"
      expect(page).to have_selector "li", text: "プロフィール画像は5MB未満のファイルを選択してください"
    end

    it "無効なファイル形式はプロフィール画像として登録しない" do
      expect {
        fill_in "名前", with: "Example User"
        fill_in "メールアドレス", with: "user@example.com"
        attach_file("user_avater", "#{Rails.root}/spec/fixtures/test.html") # 無効なファイル形式を添付
        fill_in "パスワード", with: "password"
        fill_in "パスワード(確認)", with: "password"
        click_button "Create my account"
      }.to_not change(User, :count)

      expect(page).to have_selector "div#error_explanation"
      expect(page).to have_css "div.field_with_errors"
      expect(page).to have_selector "li", text: "プロフィール画像のフォーマットが無効です"
    end
  end
end
