require 'rails_helper'

RSpec.describe "DELETE /users/:id", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let!(:other_user) { FactoryBot.create(:user) }
  let(:admin_user) { FactoryBot.create(:user, :admin) }

  context "管理者ユーザーがログインしている場合" do
    before { log_in_as(admin_user) }

    it "リクエストが成功する" do
      delete user_path(other_user)
      expect(response.status).to eq 302
    end

    it "ユーザーを削除する" do
      expect {
        delete user_path(other_user)
      }.to change(User, :count).by(-1)
    end

    it "indexページにリダイレクトする" do
      delete user_path(other_user)
      expect(response).to redirect_to users_url
    end
  end

  context "管理者ではないユーザーがログインしている場合" do
    before { log_in_as(user) }

    it "リクエストが成功する" do
      delete user_path(other_user)
      expect(response.status).to eq 302
    end

    it "ユーザーを削除しない" do
      expect {
        delete user_path(other_user)
      }.to_not change(User, :count)
    end

    it "rootページにリダイレクトする" do
      delete user_path(other_user)
      expect(response).to redirect_to root_url
    end
  end

  context "ログインしていない場合" do
    it "リクエストが成功する" do
      delete user_path(other_user)
      expect(response.status).to eq 302
    end

    it "ユーザーを削除しない" do
      expect {
        delete user_path(other_user)
      }.to_not change(User, :count)
    end

    it "エラーを表示する" do
      delete user_path(other_user)
      follow_redirect!
      expect(response.body).to include "Please log in."
    end

    it "loginページにリダイレクトする" do
      delete user_path(other_user)
      expect(response).to redirect_to login_url
    end
  end
end
