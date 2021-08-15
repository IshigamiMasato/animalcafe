require 'rails_helper'

RSpec.describe "UsersDestroy", type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:other_user) { FactoryBot.create(:user) }

  context "ログインしていない場合" do
    it "ユーザーを削除できず、loginページにリダイレクトする" do
      expect {
        delete user_path(user)
      }.to_not change(User, :count)
      expect(response).to redirect_to login_url
    end
  end

  context "管理者ではないユーザーがログインしている場合" do
    it "ユーザーを削除できず、homeページにリダイレクトする" do
      log_in_as(user)
      expect {
        delete user_path(other_user)
      }.to_not change(User, :count)
      expect(response).to redirect_to root_url
    end
  end
end
