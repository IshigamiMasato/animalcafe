require 'rails_helper'

RSpec.describe "UsersEdit", type: :system do
  let(:user) { FactoryBot.create(:user) }

  before { log_in_as(user) }

  context "有効な編集情報を入力した場合" do
    it "編集をする" do
      click_link "プロフィール編集"
      expect(current_path).to eq edit_user_path(user)

      expect(page).to have_field "名前", with: user.name
      expect(page).to have_field "メールアドレス", with: user.email

      fill_in "名前", with: "Foo Bar"
      fill_in "メールアドレス", with: "foo@bar.com"
      fill_in "パスワード", with: ""
      fill_in "パスワード(確認)", with: ""
      click_button "Save changes"

      expect(page).to have_selector "div.alert-success"
      expect(current_path).to eq user_path(user)

      user.reload
      expect(user.name).to eq "Foo Bar"
      expect(user.email).to eq "foo@bar.com"
    end
  end

  context "無効な編集情報を入力した場合" do
    it "編集しない" do
      click_link "プロフィール編集"
      expect(current_path).to eq edit_user_path(user)

      expect(page).to have_field "名前", with: user.name
      expect(page).to have_field "メールアドレス", with: user.email

      fill_in "名前", with: ""
      fill_in "メールアドレス", with: "foo@invalid"
      fill_in "パスワード", with: "foo"
      fill_in "パスワード(確認)", with: "bar"
      click_button "Save changes"

      expect(page).to have_selector "div#error_explanation"
      expect(page).to have_selector ".alert-danger"

      user.reload
      expect(user.name).to_not eq ""
      expect(user.email).to_not eq "foo@invalid"
    end
  end
end
