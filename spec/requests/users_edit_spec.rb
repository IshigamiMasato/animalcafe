require 'rails_helper'

RSpec.describe "UsersEdit", type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:other_user) { FactoryBot.create(:user) }

  describe "GET /users/:id/edit" do
    context "ログインしている場合" do
      before { log_in_as(user) }

      it "リクエストが成功する" do
        get edit_user_path(user)
        expect(response.status).to eq 200
      end

      it "名前を表示する" do
        get edit_user_path(user)
        expect(response.body).to include user.name
      end

      it "メールアドレスを表示する" do
        get edit_user_path(user)
        expect(response.body).to include user.email
      end

      it "他ユーザーの編集ページにアクセスせず、rootページにリダイレクトする" do
        get edit_user_path(other_user)
        expect(response).to redirect_to root_url
      end
    end

    context "ログインしていない場合" do
      it "リクエストが成功する" do
        get edit_user_path(user)
        expect(response.status).to eq 302
      end

      it "エラーメッセージを表示する" do
        get edit_user_path(user)
        follow_redirect!
        expect(response.body).to include "Please log in."
      end

      it "loginページにリダイレクトする" do
        get edit_user_path(user)
        expect(response).to redirect_to login_url
      end

      it "フレンドリーフォワーディングのテスト" do
        get edit_user_path(user)
        expect(session[:forwarding_url]).to eq edit_user_url(user)
        log_in_as(user)
        expect(session[:forwarding_url].nil?).to eq true
        expect(response).to redirect_to edit_user_url(user)
      end
    end
  end

  describe "PATCH /users/:id" do
    let(:edit_user_params) { FactoryBot.attributes_for(:user) }

    context "ログインしている場合" do
      before { log_in_as(user) }

      it "リクエストが成功する" do
        patch user_path(user), params: { user: edit_user_params }
        expect(response.status).to eq 302
      end

      it "ユーザー名を更新する" do
        patch user_path(user), params: { user: edit_user_params }
        user.reload
        expect(user.name).to eq edit_user_params[:name]
      end

      it "profileページにリダイレクトする" do
        patch user_path(user), params: { user: edit_user_params }
        expect(response).to redirect_to user
      end

      it "他ユーザーのprofile編集はせず、rootページにリダイレクトする" do
        patch user_path(other_user), params: { user: edit_user_params }
        expect(response).to redirect_to root_url
      end

      it "admin属性の変更は無効" do
        expect(user.reload.admin?).to eq false
        patch user_path(user), params: { user: { admin: true } }
        expect(user.reload.admin?).to eq false
      end
    end

    context "ログインしていない場合" do
      it "リクエストが成功する" do
        patch user_path(user), params: { user: edit_user_params }
        expect(response.status).to eq 302
      end

      it "エラーメッセージを表示する" do
        get edit_user_path(user)
        follow_redirect!
        expect(response.body).to include "Please log in."
      end

      it "loginページにリダイレクトする" do
        get edit_user_path(user)
        expect(response).to redirect_to login_url
      end
    end
  end
end
