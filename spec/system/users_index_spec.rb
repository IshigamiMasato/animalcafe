require 'rails_helper'

RSpec.describe "paginationレイアウトとユーザー削除のテスト", type: :system do
  let!(:admin_user) { FactoryBot.create(:user, :admin) }
  let!(:non_activated_user) { FactoryBot.create(:user, :no_activated) }
  let!(:other_users) { FactoryBot.create_list(:user, 30) }
  let(:non_admin_user) { FactoryBot.create(:user) }

  context "管理者ユーザーでログインした場合" do
    it "paginationとdeleteリンクを正しく表示し、ユーザーを削除する" do
      log_in_as(admin_user)
      click_link "Users", match: :first
      expect(current_path).to eq users_path
      expect(page).to_not have_link non_activated_user.name, href: user_path(non_activated_user)
      expect(page).to have_css "div.pagination", count: 2
      first_page_of_users = User.where(activated: true).paginate(page: 1, per_page: 20)
      first_page_of_users.each do |user|
        expect(page).to have_link user.name
        unless user == admin_user
          expect(page).to have_link "delete", href: user_path(user)
        end
      end
      expect {
        click_link "delete", match: :first
      }.to change(User, :count).by(-1)
    end
  end

  context "管理者ではないユーザーでログインした場合" do
    it "deleteリンクを表示しない" do
      log_in_as(non_admin_user)
      click_link "Users", match: :first
      expect(current_path).to eq users_path
      expect(page).to_not have_link "delete"
    end
  end
end
