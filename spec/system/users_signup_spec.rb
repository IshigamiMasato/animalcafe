require 'rails_helper'

RSpec.describe "UsersSignup", type: :system do
  before do
    visit root_path
    click_link "Sign up now!"
  end

  context "有効な登録情報を入力した場合" do
    scenario "ユーザーが登録され、有効化するとprofileページにリダイレクトする" do
      user_params = FactoryBot.attributes_for(:user, :no_activated)

      expect {
        post users_path, params: { user: user_params }
      }.to change(User, :count).by(1)

      user = controller.instance_variable_get("@user") # コントローラー内のインスタンス変数を取得

      expect(ActionMailer::Base.deliveries.size).to eq 1 # 送られたメール件数が1件なのを確認
      expect(user.activated?).to eq false # 登録後はまだ有効化されていない

      # 有効化していない状態でログインしてみる
      log_in_as(user)
      within ".navbar-nav" do # ログインしていないことを確認
        expect(page).to have_link "Log in"
        expect(page).to_not have_link "Log out"
        expect(page).to_not have_link href: user_path(user)
      end

      # 有効化トークンが不正な場合
      visit edit_account_activation_path("invalid token", email: user.email)
      within ".navbar-nav" do # ログインしていないことを確認
        expect(page).to have_link "Log in"
        expect(page).to_not have_link "Log out"
        expect(page).to_not have_link href: user_path(user)
      end

      # トークンは正しいがメールアドレスが無効な場合
      visit edit_account_activation_path(user.activation_token, email: "wrong")
      within ".navbar-nav" do # ログインしていないことを確認
        expect(page).to have_link "Log in"
        expect(page).to_not have_link "Log out"
        expect(page).to_not have_link href: user_path(user)
      end

      # 有効化トークンが正しい場合
      visit edit_account_activation_path(user.activation_token, email: user.email)
      expect(user.reload.activated?).to eq true

      expect(current_path).to eq user_path(user)
      expect(page).to have_selector "div.alert-success" # flashの成功メッセージが表示されていることを確認

      within ".navbar-nav" do # ログインしていることを確認
        expect(page).to_not have_link "Log in"
        expect(page).to have_link "Log out"
        expect(page).to have_link href: user_path(user)
      end
    end

    scenario "プロフィール画像を登録できる" do
      user_params = FactoryBot.attributes_for(:user, :no_activated, :add_image_avater)

      expect {
        post users_path, params: { user: user_params }
      }.to change(User, :count).by(1)

      user = controller.instance_variable_get("@user")

      visit edit_account_activation_path(user.activation_token, email: user.email)
      expect(user.reload.activated?).to eq true

      expect(current_path).to eq user_path(user)
      expect(page).to have_selector "div.alert-success"

      within ".navbar-nav" do # ログインしていることを確認
        expect(page).to_not have_link "Log in"
        expect(page).to have_link "Log out"
        expect(page).to have_link href: user_path(user)
      end

      expect(user.avater.attached?).to eq true # 画像がモデルに結びついていることを確認
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
        click_button "Create my account"
      }.to_not change(User, :count)

      expect(page).to have_selector "#error_explanation" # _error_messages.html.erbが描画されていることの確認
      expect(page).to have_css ".field_with_errors" # 無効内容の送信により元のぺーじに戻ったら、railsはエラー箇所を.field_with_errorsクラスのdivタグで囲む
      expect(page).to have_selector "li", text: "名前を入力してください"
      expect(page).to have_selector "li", text: "メールアドレスは不正な値です"
      expect(page).to have_selector "li", text: "パスワード(確認)とパスワードの入力が一致しません"
      expect(page).to have_selector "li", text: "パスワードは6文字以上で入力してください"
    end

    scenario "5MB以上の画像はプロフィール画像として登録できない" do
      expect {
        fill_in "名前", with: "Example User"
        fill_in "メールアドレス", with: "user@example.com"
        attach_file("user_avater", "#{Rails.root}/spec/fixtures/10MB.png") # 5MB以上のファイル画像を添付
        fill_in "パスワード", with: "password"
        fill_in "パスワード(確認)", with: "password"
        click_button "Create my account"
      }.to_not change(User, :count)

      expect(page).to have_selector "#error_explanation"
      expect(page).to have_css ".field_with_errors"
      expect(page).to have_selector "li", text: "プロフィール画像は5MB未満のファイルを選択してください"
    end

    scenario "無効なファイル形式はプロフィール画像として登録できない" do
      expect {
        fill_in "名前", with: "Example User"
        fill_in "メールアドレス", with: "user@example.com"
        attach_file("user_avater", "#{Rails.root}/spec/fixtures/test.html") # 無効なファイル形式を添付
        fill_in "パスワード", with: "password"
        fill_in "パスワード(確認)", with: "password"
        click_button "Create my account"
      }.to_not change(User, :count)

      expect(page).to have_selector "#error_explanation"
      expect(page).to have_css ".field_with_errors"
      expect(page).to have_selector "li", text: "プロフィール画像のフォーマットが無効です"
    end
  end
end
