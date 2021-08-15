require 'rails_helper'

RSpec.describe "UsersLogin", type: :request do
  let!(:user) { FactoryBot.create(:user) }

  context "同じサイトを2つのタブで開き、一方のタブはログアウトしている場合" do
    it "もう一方のタブでログアウトしても、エラーは発生しない" do
      get login_path
      post login_path, params: {
        session: {
          email: user.email,
          password: user.password,
        },
      }

      expect(is_logged_in?).to eq true
      expect(response).to redirect_to user
      follow_redirect!
      expect(response.body).to_not include "Log in"
      expect(response.body).to include "Log out"
      delete logout_path
      expect(is_logged_in?).to eq false
      expect(response).to redirect_to root_url
      follow_redirect!
      expect(response.body).to include "Log in"
      expect(response.body).to_not include "Log out"
      # 2番目のウィンドウでログアウトをクリックするユーザーをシュミレート
      delete logout_path
      follow_redirect!
      expect(response.body).to include "Log in"
      expect(response.body).to_not include "Log out"
    end
  end

  it "Remember me on this computerにチェックすると、ユーザーが永続化される" do
    log_in_as(user, remember_me: "1")
    expect(cookies[:remember_token].blank?).to eq false # トークンの有無で永続化を確認
  end

  it "Remember me on this computerにチェックしなければ、ユーザーは永続化されない" do
    # cookiesを保存してログイン
    log_in_as(user, remember_me: "1")
    delete logout_path
    # cookiesを削除してログイン
    log_in_as(user, remember_me: "0")
    expect(cookies[:remember_token].blank?).to eq true
  end
end
