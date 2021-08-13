require 'rails_helper'

RSpec.describe SessionsHelper, type: :helper do
  let!(:user) { FactoryBot.create(:user) }

  before { remember(user) }

  context "sessionがnil、cookiesに情報が保存されユーザーが永続化している場合" do # current_userメソッドのelsifの分岐の部分をテスト
    it "current_userメソッドは正しいユーザーを返す" do
      expect(current_user).to eq user
      expect(session[:user_id].nil?).to eq false # sessionからログインしていることの確認
    end
  end

  context "remember_digestの値がもとの値から変わった場合" do # current_userメソッドの分岐後のauthenticated?の部分をテスト
    it "current_userメソッドはnilを返す" do
      user.update_attribute(:remember_digest, User.digest(User.new_token))
      expect(current_user).to eq nil
    end
  end
end
