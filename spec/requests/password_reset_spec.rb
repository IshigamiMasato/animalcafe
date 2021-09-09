require 'rails_helper'

RSpec.describe "PasswordReset", type: :request do
  describe "GET /password_resets/new" do
    it "リクエストが成功する" do
      get new_password_reset_path
      expect(response.status).to eq 200
    end
  end

  describe "POST /password_resets" do
    context "パラメータが有効な場合" do
      let!(:user) { FactoryBot.create(:user) }

      it "リクエストが成功する" do
        post password_resets_path, params: { password_reset: { email: user.email } }
        expect(response.status).to eq 302
      end

      it "メールを送信する" do
        post password_resets_path, params: { password_reset: { email: user.email } }
        expect(ActionMailer::Base.deliveries.size).to eq 1
      end

      it "メッセージを表示する" do
        post password_resets_path, params: { password_reset: { email: user.email } }
        follow_redirect!
        expect(response.body).to include "パスワード変更メールを送信しました"
      end

      it "rootページにリダイレクトする" do
        post password_resets_path, params: { password_reset: { email: user.email } }
        expect(response).to redirect_to root_url
      end
    end

    context "パラメータが無効な場合" do
      it "リクエストが成功する" do
        post password_resets_path, params: { password_reset: { email: "user@invalid" } }
        expect(response.status).to eq 200
      end

      it "メールを送信しない" do
        post password_resets_path, params: { password_reset: { email: "user@invalid" } }
        expect(ActionMailer::Base.deliveries.size).to eq 0
      end

      it "エラーを表示する" do
        post password_resets_path, params: { password_reset: { email: "user@invalid" } }
        expect(response.body).to include "メールアドレスが見つかりません"
      end
    end
  end

  describe "GET /password_resets/:id/edit" do
    before do
      user = FactoryBot.create(:user)
      post password_resets_path, params: { password_reset: { email: user.email } }
      @user = controller.instance_variable_get("@user")
    end

    context "トークンとメールアドレス両方が正しい場合" do
      it "リクエストが成功する" do
        get edit_password_reset_path(@user.reset_token, email: @user.email)
        expect(response.status).to eq 200
      end

      it "hddenフィールドにユーザーのメールアドレスが含まれている" do
        get edit_password_reset_path(@user.reset_token, email: @user.email)
        expect(response.body).to include @user.email
      end
    end

    context "無効なユーザーの場合" do
      before { @user.toggle!(:activated) }

      it "リクエストが成功する" do
        get edit_password_reset_path(@user.reset_token, email: @user.email)
        expect(response.status).to eq 302
      end

      it "rootページにリダイレクトする" do
        get edit_password_reset_path(@user.reset_token, email: @user.email)
        expect(response).to redirect_to root_url
      end
    end

    context "トークンは正しいがメールアドレスが無効な場合" do
      it "リクエストが成功する" do
        get edit_password_reset_path(@user.reset_token, email: "wrong")
        expect(response.status).to eq 302
      end

      it "rootページにリダイレクトする" do
        get edit_password_reset_path(@user.reset_token, email: "wrong")
        expect(response).to redirect_to root_url
      end
    end

    context "含まれる有効化トークンが無効な場合" do
      it "リクエストが成功する" do
        get edit_password_reset_path("invalid token", email: "wrong")
        expect(response.status).to eq 302
      end

      it "rootページにリダイレクトする" do
        get edit_password_reset_path("invalid token", email: "wrong")
        expect(response).to redirect_to root_url
      end
    end
  end

  describe "PATCH /password_resets/:id" do
    before do
      user = FactoryBot.create(:user)
      post password_resets_path, params: { password_reset: { email: user.email } }
      @user = controller.instance_variable_get("@user")
    end

    context "パラメータが有効な場合" do
      it "リクエストが成功する" do
        patch password_reset_path(@user.reset_token, email: @user.email), params: { user: { password: "password",
                                                                                            password_confirmation: "password",
        } }
        expect(response.status).to eq 302
      end

      it "ログインする" do
        patch password_reset_path(@user.reset_token, email: @user.email), params: { user: { password: "password",
                                                                                            password_confirmation: "password",
        } }
        expect(is_logged_in?).to eq true
      end

      it "reset_digestがnilとなる" do
        patch password_reset_path(@user.reset_token, email: @user.email), params: { user: { password: "password",
                                                                                            password_confirmation: "password",
        } }
        expect(@user.reload.reset_digest).to eq nil
      end

      it "メッセージを表示する" do
        patch password_reset_path(@user.reset_token, email: @user.email), params: { user: { password: "password",
                                                                                            password_confirmation: "password",
        } }
        follow_redirect!
        expect(response.body).to include "パスワードを変更しました"
      end

      it "rootページにリダイレクトする" do
        patch password_reset_path(@user.reset_token, email: @user.email), params: { user: { password: "password",
                                                                                            password_confirmation: "password",
        } }
        expect(response).to redirect_to @user
      end
    end

    context "パラメーターが無効な場合" do
      it "リクエストが成功する" do
        patch password_reset_path(@user.reset_token, email: @user.email), params: { user: { password: "",
                                                                                            password_confirmation: "",
        } }
        expect(response.status).to eq 200
      end

      it "ログインしない" do
        patch password_reset_path(@user.reset_token, email: @user.email), params: { user: { password: "",
                                                                                            password_confirmation: "",
        } }
        expect(is_logged_in?).to eq false
      end

      it "エラーを表示する" do
        patch password_reset_path(@user.reset_token, email: @user.email), params: { user: { password: "",
                                                                                            password_confirmation: "",
        } }
        expect(response.body).to include "パスワードを入力してください"
      end
    end

    context "トークンの有効期限が切れる場合" do
      before { @user.update_attribute(:reset_sent_at, 3.hours.ago) }

      it "リクエストが成功する" do
        patch password_reset_path(@user.reset_token, email: @user.email), params: { user: { password: "password",
                                                                                            password_confirmation: "password",
        } }
        expect(response.status).to eq 302
      end

      it "パスワード再設定(メール送信)ページにリダイレクトする" do
        patch password_reset_path(@user.reset_token, email: @user.email), params: { user: { password: "password",
                                                                                            password_confirmation: "password",
        } }
        expect(response).to redirect_to new_password_reset_url
      end

      it "エラーを表示する" do
        patch password_reset_path(@user.reset_token, email: @user.email), params: { user: { password: "password",
                                                                                            password_confirmation: "password",
        } }
        follow_redirect!
        expect(response.body).to include "パスワード変更メールの有効期限が切れています"
      end
    end
  end
end
