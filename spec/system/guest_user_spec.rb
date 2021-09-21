require 'rails_helper'

RSpec.describe "GuestUser", type: :system do
  context "ゲストユーザーがDBにない場合" do
    it "新たに作成してログインする" do
      visit root_path
      expect(current_path).to eq root_path
      click_link "ログイン", match: :first
      expect(current_path).to eq login_path

      click_link "ゲストログインはこちら"
      user = User.last
      expect(current_path).to eq shops_path
      expect(page).to have_selector "div.alert-success"
      within ".navbar-right" do # ログインしていることを確認
        expect(page).to_not have_link "ログイン"
        expect(page).to have_link "ログアウト"
        expect(page).to have_link href: user_path(user)
      end

      # ゲストユーザーはprofile編集できない
      find(".user_icon").click
      expect(current_path).to eq user_path(user)
      click_link "プロフィール編集"
      expect(current_path).to eq edit_user_path(user)

      click_button "Save changes"

      expect(current_path).to eq root_path
      expect(page).to have_selector "div.alert-warning"
    end
  end

  context "ゲストユーザーがDBにある場合" do
    let!(:guest_user) { FactoryBot.create(:guest_user) }

    it "検索してログインする" do
      visit root_path
      expect(current_path).to eq root_path
      click_link "ログイン", match: :first
      expect(current_path).to eq login_path

      click_link "ゲストログインはこちら"
      user = User.last
      expect(current_path).to eq shops_path
      expect(page).to have_selector "div.alert-success"
      within ".navbar-right" do # ログインしていることを確認
        expect(page).to_not have_link "ログイン"
        expect(page).to have_link "ログアウト"
        expect(page).to have_link href: user_path(user)
      end
    end
  end
end
