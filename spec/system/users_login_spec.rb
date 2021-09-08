require 'rails_helper'

RSpec.describe "UsersLogin", type: :system do
  let!(:user) { FactoryBot.create(:user) }

  it "ログインする" do
    visit root_path
    expect(current_path).to eq root_path

    click_link "Log in", match: :first
    expect(current_path).to eq login_path

    # 有効なメールアドレスと、無効なパスワードをログイン情報に入力した場合
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: "invalid"
    click_button "Log in"

    expect(page).to have_selector "div.alert-danger"
    within ".navbar-right" do # ログインしていないことを確認
      expect(page).to have_link "Log in"
      expect(page).to_not have_link "Log out"
      expect(page).to_not have_link href: user_path(user)
    end

    click_link "ANIMAL CAFE"
    expect(current_path).to eq root_path
    # flash.nowの部分をテスト
    expect(page).to_not have_selector "div.alert-danger"

    # メールアドレスとパスワードが無効なログイン情報を入力した場合
    visit root_path
    expect(current_path).to eq root_path

    click_link "Log in", match: :first
    expect(current_path).to eq login_path

    fill_in "メールアドレス", with: ""
    fill_in "パスワード", with: ""
    click_button "Log in"

    expect(page).to have_selector "div.alert-danger"
    within ".navbar-right" do # ログインしていないことを確認
      expect(page).to have_link "Log in"
      expect(page).to_not have_link "Log out"
      expect(page).to_not have_link href: user_path(user)
    end

    click_link "ANIMAL CAFE"
    expect(current_path).to eq root_path
    # flash.nowの部分をテスト
    expect(page).to_not have_selector "div.alert-danger"

    # 有効なログイン情報を入力した場合
    visit root_path
    expect(current_path).to eq root_path

    click_link "Log in", match: :first
    expect(current_path).to eq login_path

    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password
    click_button "Log in"

    expect(current_path).to eq shops_path
    within ".navbar-right" do # ログインしていることを確認
      expect(page).to_not have_link "Log in"
      expect(page).to have_link "Log out"
      expect(page).to have_link href: user_path(user)
    end

    # ログアウトする
    click_link "Log out", match: :first

    expect(current_path).to eq root_path
    within ".navbar-right" do # ログアウトしていることを確認
      expect(page).to have_link "Log in"
      expect(page).to_not have_link "Log out"
      expect(page).to_not have_link href: user_path(user)
    end
  end
end
