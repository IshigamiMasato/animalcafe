require 'rails_helper'

RSpec.describe "GET /account_activations/:id/edit", type: :request do
  before do
    user_params = FactoryBot.attributes_for(:user, :no_activated)
    post users_path, params: { user: user_params }
    @user = controller.instance_variable_get("@user")
  end

  context "トークンとメールアドレス両方が正しい場合" do
    it "リクエストが成功する" do
      get edit_account_activation_path(@user.activation_token, email: @user.email)
      expect(response.status).to eq 302
    end

    it "ユーザーが有効化する" do
      get edit_account_activation_path(@user.activation_token, email: @user.email)
      expect(@user.reload.activated?).to eq true
    end

    it "ログインする" do
      get edit_account_activation_path(@user.activation_token, email: @user.email)
      expect(is_logged_in?).to eq true
    end

    it "profileページにリダイレクトする" do
      get edit_account_activation_path(@user.activation_token, email: @user.email)
      expect(response).to redirect_to @user
    end
  end

  context "トークンは正しいがメールアドレスが無効な場合" do
    it "リクエストが成功する" do
      get edit_account_activation_path(@user.activation_token, email: "wrong")
      expect(response.status).to eq 302
    end

    it "ユーザーが有効化しない" do
      get edit_account_activation_path(@user.activation_token, email: "wrong")
      expect(@user.reload.activated?).to eq false
    end

    it "ログインしない" do
      get edit_account_activation_path(@user.activation_token, email: "wrong")
      expect(is_logged_in?).to eq false
    end

    it "rootページにリダイレクトする" do
      get edit_account_activation_path(@user.activation_token, email: "wrong")
      expect(response).to redirect_to root_url
    end
  end

  context "含まれる有効化トークンが無効な場合" do
    it "リクエストが成功する" do
      get edit_account_activation_path("invalid token", email: @user.email)
      expect(response.status).to eq 302
    end

    it "ユーザーが有効化しない" do
      get edit_account_activation_path("invalid token", email: @user.email)
      expect(@user.reload.activated?).to eq false
    end

    it "ログインしない" do
      get edit_account_activation_path("invalid token", email: @user.email)
      expect(is_logged_in?).to eq false
    end

    it "rootページにリダイレクトする" do
      get edit_account_activation_path("invalid token", email: @user.email)
      expect(response).to redirect_to root_url
    end
  end
end
