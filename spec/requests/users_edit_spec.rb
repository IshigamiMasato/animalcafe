require 'rails_helper'

RSpec.describe "UsersEdit", type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:other_user) { FactoryBot.create(:user) }

  context "ログインした状態で、他のユーザーのprofile編集画面にアクセスする場合" do
    it "アクセスできず、homeページにリダイレクトする" do
      log_in_as(other_user)
      get edit_user_path(user)
      expect(flash.blank?).to eq true
      expect(response).to redirect_to root_url
    end
  end

  context "ログインした状態で、他のユーザーのprofile編集を行う場合" do
    it "profile編集はできず、homeページにリダイレクトする" do
      log_in_as(other_user)
      patch user_path(user), params: {
        user: {
          name: user.name,
          email: user.email,
        },
      }
      expect(flash.blank?).to eq true
      expect(response).to redirect_to root_url
    end
  end

  context "ログインしていない場合" do
    it "profile編集画面は表示されず、loginページにリダイレクトする" do
      get edit_user_path(user)
      expect(flash.blank?).to eq false
      expect(response).to redirect_to login_url
    end

    it "profile編集はできず、loginページにリダイレクトする" do
      patch user_path(user), params: {
        user: {
          name: user.name,
          email: user.email,
        },
      }
      expect(flash.blank?).to eq false
      expect(response).to redirect_to login_url
    end
  end

  it "フレンドリーフォワーディング" do
    get edit_user_path(user)
    expect(session[:forwarding_url]).to eq edit_user_url(user) # リクエストしたURLがsessionに保存されているか確認
    log_in_as(user)
    expect(session[:forwarding_url].nil?).to eq true # sessionが削除されているか
    expect(response).to redirect_to edit_user_url(user)

    patch user_path(user), params: {
      user: {
        name: "Foo Bar",
        email: "foo@bar.com",
        password: "",
        password_confirmation: "",
      },
    }
    expect(flash.blank?).to eq false
    expect(response).to redirect_to user
    user.reload
    expect(user.name).to eq "Foo Bar"
    expect(user.email).to eq "foo@bar.com"
  end

  it "webを通じたadmin属性の変更は無効" do
    log_in_as(other_user)
    expect(other_user.admin?).to eq false
    patch user_path(other_user), params: {
      user: {
        password: other_user.password,
        password_confirmation: other_user.password,
        admin: true,
      },
    }
    expect(other_user.reload.admin?).to eq false
  end
end
