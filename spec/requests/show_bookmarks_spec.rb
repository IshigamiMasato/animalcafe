require 'rails_helper'

RSpec.describe "ShowBookmarks", type: :request do
  describe "GET /users/:id/bookmarking" do
    let(:user) { FactoryBot.create(:user) }

    it "ログインしていないとloginページへリダイレクトする" do
      get bookmarking_user_path(user)
      expect(response).to redirect_to login_url
    end
  end
end
