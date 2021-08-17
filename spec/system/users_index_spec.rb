require 'rails_helper'

RSpec.describe "UsersIndex", type: :system do
  describe "pagination" do
    let!(:admin_user) { FactoryBot.create(:admin_user) }
    let!(:non_activated_user) { FactoryBot.create(:user, :no_activated) }
    let(:non_admin_user) { FactoryBot.create(:user) }
    let!(:other_users) { FactoryBot.create_list(:user, 30) }

    context "管理者ユーザーでログインした場合" do
      scenario "paginationとdeleteリンクが正しく表示され、ユーザーを削除できる" do
        log_in_as(admin_user)
        click_link "Users", match: :first
        expect(current_path).to eq users_path
        expect(page).to_not have_link non_activated_user.name, href: user_path(non_activated_user) # 有効ではないユーザーのリンクは表示されない
        expect(page).to have_css "div.pagination", count: 2
        first_page_of_users = User.where(activated: true).paginate(page: 1)
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
      scenario "deleteリンクは表示されない" do
        log_in_as(non_admin_user)
        click_link "Users", match: :first
        expect(current_path).to eq users_path
        expect(page).to_not have_link "delete"
      end
    end
  end
end
