require 'rails_helper'

RSpec.describe "UsersIndex", type: :request do
  context "ログインしていない場合" do
    it "loginページにリダイレクトする" do
      get users_path
      expect(response).to redirect_to login_url
    end
  end
end
