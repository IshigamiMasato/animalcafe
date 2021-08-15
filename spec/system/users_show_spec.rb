require 'rails_helper'

RSpec.describe "UsersShow", type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:other_user) { FactoryBot.create(:user) }

  context "ログインしている場合" do
    before { log_in_as(user) }

    scenario "ログインユーザーのshowページに、プロフィール編集リンクがある" do
      visit user_path(user)
      expect(current_path).to eq user_path(user)

      expect(page).to have_link "プロフィール編集"
    end

    scenario "ログインユーザーとは別ユーザーのshowページに、プロフィール編集リンクがない" do
      visit user_path(other_user)
      expect(current_path).to eq user_path(other_user)

      expect(page).to_not have_link "プロフィール編集"
    end
  end

  context "ログインしていない場合" do
    scenario "ユーザーのshowページに、プロフィール編集リンクがない" do
      visit user_path(user)
      expect(current_path).to eq user_path(user)

      expect(page).to_not have_link "プロフィール編集"
    end
  end
end