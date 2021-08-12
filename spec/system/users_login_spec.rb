require 'rails_helper'

RSpec.describe "UsersLogin", type: :system do
  let!(:user) { FactoryBot.create(:user) }

  context "有効なログイン情報を入力した場合" do
    scenario "ログインできprofileページにリダイレクトした後、ログアウトしHomeページにリダイレクトする" do
      visit login_path
      expect(current_path).to eq login_path

      fill_in "Email", with: "user@test.com"
      fill_in "Password", with: "foobar"
      click_button "Log in"

      within ".navbar-nav" do # ログインしていることを確認
        expect(page).to_not have_link "Log in"
        expect(page).to have_link href: user_path(user)
      end

      expect(current_path).to eq user_path(user)

      expect(page).to_not have_link "Log in"
      expect(page).to have_link "Log out"
      expect(page).to have_link "Profile"

      click_link "Log out", match: :first

      within ".navbar-nav" do # ログインしていないことを確認
        expect(page).to have_link "Log in"
        expect(page).to_not have_link href: user_path(user)
      end

      expect(current_path).to eq root_path
    end
  end

  context "有効なメールアドレスと、無効なパスワードをログイン情報に入力した場合" do
    scenario "ログインできず、log inページが再描画される" do
      visit login_path
      expect(current_path).to eq login_path

      fill_in "Email", with: "user@test.com"
      fill_in "Password", with: "invalid"
      click_button "Log in"

      within ".navbar-nav" do # ログインしていないことを確認
        expect(page).to have_link "Log in"
        expect(page).to_not have_link href: user_path(user)
      end

      expect(current_path).to eq login_path
      expect(page).to have_selector "div.alert-danger"

      visit root_path
      expect(page).to_not have_selector "div.alert-danger"
    end
  end

  context "メールアドレスとパスワードが無効なログイン情報を入力した場合" do
    scenario "ログインできず、log inページが再描画される" do
      visit login_path
      expect(current_path).to eq login_path

      fill_in "Email", with: ""
      fill_in "Password", with: ""
      click_button "Log in"

      within ".navbar-nav" do # ログインしていないことを確認
        expect(page).to have_link "Log in"
        expect(page).to_not have_link href: user_path(user)
      end

      expect(current_path).to eq login_path
      expect(page).to have_selector "div.alert-danger"

      visit root_path
      expect(page).to_not have_selector "div.alert-danger"
    end
  end
end
