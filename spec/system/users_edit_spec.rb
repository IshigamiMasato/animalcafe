require 'rails_helper'

RSpec.describe "UsersEdit", type: :system do
  let!(:user) { FactoryBot.create(:user) }

  before { log_in_as(user) }

  context "有効な編集情報を入力した場合" do
    scenario "編集が成功し、profileページにリダイレクトする" do
      # プロフィール編集
      expect(current_path).to eq user_path(user)
      click_link "プロフィール編集"
      expect(current_path).to eq edit_user_path(user)

      fill_in "名前", with: "Foo Bar"
      fill_in "メールアドレス", with: "foo@bar.com"
      fill_in "パスワード", with: ""
      fill_in "パスワード(確認)", with: ""
      click_button "Save changes"

      # フラッシュメッセージがあることを確認
      expect(page).to have_selector "div.alert-success"
      expect(current_path).to eq user_path(user)

      # プロフィール情報が変更されていることの確認
      user.reload
      expect(user.name).to eq "Foo Bar"
      expect(user.email).to eq "foo@bar.com"
    end
  end

  context "無効な編集情報を入力した場合" do
    scenario "編集が失敗する" do
      # プロフィール編集
      expect(current_path).to eq user_path(user)
      click_link "プロフィール編集"
      expect(current_path).to eq edit_user_path(user)

      fill_in "名前", with: ""
      fill_in "メールアドレス", with: "foo@invalid"
      fill_in "パスワード", with: "foo"
      fill_in "パスワード(確認)", with: "bar"
      click_button "Save changes"

      # プロフィール情報が変更されていないことの確認
      user.reload
      expect(user.name).to_not eq ""
      expect(user.email).to_not eq "foo@invalid"

      # エラーメッセージ数の確認
      within ".alert-danger" do
        expect(page).to have_content "The form contains 4 error."
      end
    end
  end
end
