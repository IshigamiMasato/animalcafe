require 'rails_helper'

RSpec.describe "POST /shops/:shop_id/reviews", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:shop) { FactoryBot.create(:shop, user: user) }

  context "ログインしていない場合" do
    it "リクエストが成功する" do
      post shop_reviews_path(shop), params: { review: { shop_id: 1, score: 1 } }
      expect(response.status).to eq 302
    end
    it "ログインページにリダイレクトする" do
      post shop_reviews_path(shop), params: { review: { shop_id: 1, score: 1 } }
      expect(response).to redirect_to login_url
    end
  end
end
