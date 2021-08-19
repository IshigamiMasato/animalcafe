require 'rails_helper'

RSpec.describe "UsersLogin", type: :system do
  let!(:user) { FactoryBot.create(:user) }

  context "有効なログイン情報を入力した場合" do
    it "ログインし、ログアウトする" do
      visit login_path
      expect(current_path).to eq login_path

      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      click_button "Log in"

      expect(current_path).to eq user_path(user)
      within ".navbar-nav" do # ログインしていることを確認
        expect(page).to_not have_link "Log in"
        expect(page).to have_link "Log out"
        expect(page).to have_link href: user_path(user)
      end

      click_link "Log out", match: :first

      expect(current_path).to eq root_path
      within ".navbar-nav" do # ログアウトしていることを確認
        expect(page).to have_link "Log in"
        expect(page).to_not have_link "Log out"
        expect(page).to_not have_link href: user_path(user)
      end
    end
  end

  context "有効なメールアドレスと、無効なパスワードをログイン情報に入力した場合" do
    it "ログインしない" do
      visit login_path
      expect(current_path).to eq login_path

      fill_in "Email", with: user.email
      fill_in "Password", with: "invalid"
      click_button "Log in"

      expect(page).to have_selector "div.alert-danger"
      within ".navbar-nav" do # ログインしていないことを確認
        expect(page).to have_link "Log in"
        expect(page).to_not have_link "Log out"
        expect(page).to_not have_link href: user_path(user)
      end

      click_link "ANIMAL CAFE"
      expect(current_path).to eq root_path
      # flash.nowの部分をテスト
      expect(page).to_not have_selector "div.alert-danger"
    end
  end

  context "メールアドレスとパスワードが無効なログイン情報を入力した場合" do
    it "ログインしない" do
      visit login_path
      expect(current_path).to eq login_path

      fill_in "Email", with: ""
      fill_in "Password", with: ""
      click_button "Log in"

      expect(page).to have_selector "div.alert-danger"
      within ".navbar-nav" do # ログインしていないことを確認
        expect(page).to have_link "Log in"
        expect(page).to_not have_link "Log out"
        expect(page).to_not have_link href: user_path(user)
      end

      click_link "ANIMAL CAFE"
      expect(current_path).to eq root_path
      # flash.nowの部分をテスト
      expect(page).to_not have_selector "div.alert-danger"
    end
  end
end
