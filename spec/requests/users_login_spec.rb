require 'rails_helper'

RSpec.describe "UsersLogin", type: :request do
  describe "GET /login" do
    it "リクエストが成功する" do
      get login_path
      expect(response.status).to eq 200
    end
  end

  describe "POST /login" do
    context "パラメータが有効で、ユーザーが有効な場合" do
      let!(:user) { FactoryBot.create(:user) }

      it "リクエストが成功する" do
        post login_path, params: { session: { email: user.email,
                                              password: user.password,
        } }
        expect(response.status).to eq 302
      end

      it "ログインする" do
        user = FactoryBot.create(:user)
        post login_path, params: { session: { email: user.email,
                                              password: user.password,
        } }
        expect(is_logged_in?).to eq true
      end

      it "店舗一覧ページにリダイレクトする" do
        user = FactoryBot.create(:user)
        post login_path, params: { session: { email: user.email,
                                              password: user.password,
        } }
        expect(response).to redirect_to shops_url
      end

      context "パラメータが有効で、ユーザーが無効な場合" do
        let!(:non_active_user) { FactoryBot.create(:user, :no_activated) }

        it "リクエストが成功する" do
          post login_path, params: { session: { email: non_active_user.email,
                                                password: non_active_user.password,
          } }
          expect(response.status).to eq 302
        end

        it "ログインしない" do
          post login_path, params: { session: { email: non_active_user.email,
                                                password: non_active_user.password,
          } }
          expect(flash.blank?).to eq false
          expect(is_logged_in?).to eq false
        end

        it "エラーを表示する" do
          post login_path, params: { session: { email: non_active_user.email,
                                                password: non_active_user.password,
          } }
          follow_redirect!
          expect(response.body).to include "Account not activated.Check your email for the activaiton link."
        end

        it "rootページにリダイレクトする" do
          post login_path, params: { session: { email: non_active_user.email,
                                                password: non_active_user.password,
          } }
          expect(response).to redirect_to root_url
        end
      end
    end

    context "パラメータが無効な場合" do
      before { FactoryBot.create(:user) }

      it "リクエストが成功する" do
        post login_path, params: { session: { email: "user@invalid",
                                              password: "wrong",
        } }
        expect(response.status).to eq 200
      end

      it "エラーを表示する" do
        post login_path, params: { session: { email: "user@invalid",
                                              password: "wrong",
        } }
        expect(response.body).to include "invalid email/password combination"
      end
    end

    describe "Remember me on this computer機能" do
      let(:user) { FactoryBot.create(:user) }

      it "チェックを入れるとユーザーは永続化する" do
        log_in_as(user, remember_me: "1")
        expect(cookies[:remember_token].blank?).to eq false
      end

      it "チェックを外すとユーザーは永続化しない" do
        log_in_as(user, remember_me: "0")
        expect(cookies[:remember_token].blank?).to eq true
      end
    end
  end

  describe "DELETE /logout" do
    let(:user) { FactoryBot.create(:user) }

    before { log_in_as(user) }

    it "リクエストが成功する" do
      delete logout_path
      expect(response.status).to eq 302
    end

    it "ログアウトする" do
      expect(is_logged_in?).to eq true
      delete logout_path
      expect(is_logged_in?).to eq false
    end

    it "rootページにリダイレクトする" do
      delete logout_path
      expect(response).to redirect_to root_url
    end

    it "2番目のウィンドウでユーザーをログアウトする" do
      log_in_as(user)
      delete logout_path
      expect(is_logged_in?).to eq false
      # 2番目のウィンドウでログアウトをクリックするユーザーをシュミレート
      delete logout_path
      expect(is_logged_in?).to eq false
    end
  end
end
