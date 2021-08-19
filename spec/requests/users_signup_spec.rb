require 'rails_helper'

RSpec.describe "UsersSignup", type: :request do
  describe "GET /signup" do
    it "リクエストが成功する" do
      get signup_path
      expect(response.status).to eq 200
    end
  end

  describe "POST /users" do
    context "パラメータが有効な場合" do
      let(:valid_user_params) { FactoryBot.attributes_for(:user, :no_activated) }

      it "リクエストが成功する" do
        post users_path, params: { user: valid_user_params }
        expect(response.status).to eq 302
      end

      it "ユーザーを作成する" do
        expect {
          post users_path, params: { user: valid_user_params }
        }.to change(User, :count).by(1)
      end

      it "メールを送信する" do
        post users_path, params: { user: valid_user_params }
        expect(ActionMailer::Base.deliveries.size).to eq 1
      end
    end

    context "パラメータが無効な場合" do
      let(:invalid_user_params) { FactoryBot.attributes_for(:invalid_user) }

      it "リクエストが成功する" do
        post users_path, params: { user: invalid_user_params }
        expect(response.status).to eq 200
      end
      it "ユーザーを作成しない" do
        expect {
          post users_path, params: { user: invalid_user_params }
        }.to_not change(User, :count)
      end

      it "メールを送信しない" do
        post users_path, params: { user: invalid_user_params }
        expect(ActionMailer::Base.deliveries.size).to eq 0
      end
    end
  end
end
