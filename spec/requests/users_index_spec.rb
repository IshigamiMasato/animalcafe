require 'rails_helper'

RSpec.describe "GET /users", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let!(:other_user) { FactoryBot.create(:user) }

  context "ログインしている場合" do
    before { log_in_as(user) }

    it "リクエストが成功する" do
      get users_path
      expect(response.status).to eq 200
    end

    it "ユーザー名を表示する" do
      get users_path
      expect(response.body).to include user.name
      expect(response.body).to include other_user.name
    end
  end

  context "ログインしていない場合" do
    it "リクエストが成功する" do
      get users_path
      expect(response.status).to eq 302
    end
    it "loginページにリダイレクトする" do
      get users_path
      expect(response).to redirect_to login_url
    end
  end
end
