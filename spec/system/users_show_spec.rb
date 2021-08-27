require 'rails_helper'

RSpec.describe "UsersShow", type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  let(:non_activated_user) { FactoryBot.create(:user, :no_activated) }

  it "ユーザーページのリンクのテスト" do
    # ログインする前
    visit user_path(user)
    expect(current_path).to eq user_path(user)
    expect(page).to_not have_link "プロフィール編集"

    # ログインした後
    log_in_as(user)

    # ログインユーザーのshowページに、プロフィール編集リンクを表示する
    visit user_path(user)
    expect(current_path).to eq user_path(user)
    expect(page).to have_link "プロフィール編集"

    # ログインユーザーとは別ユーザーのshowページに、プロフィール編集リンクを表示しない
    visit user_path(other_user)
    expect(current_path).to eq user_path(other_user)
    expect(page).to_not have_link "プロフィール編集"

    # 有効でないユーザーのページは表示せず、homeページにリダイレクトする
    visit user_path(non_activated_user)
    expect(current_path).to eq root_path
  end
end
