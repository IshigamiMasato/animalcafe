require 'rails_helper'

RSpec.describe "Reviews", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:shop) { FactoryBot.create(:shop, user: user) }

  describe "POST /shops/:shop_id/reviews" do
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

  describe "DELETE /shops/:shop_id/reviews/:id" do
    let(:other_user) { FactoryBot.create(:user) }
    let!(:review) { FactoryBot.create(:review, user: user, shop: shop) }

    context "ログインしていない場合" do
      it "リクストが成功する" do
        delete shop_review_path(shop, review)
        expect(response.status).to eq 302
      end

      it "ログインページにリダイレクトする" do
        delete shop_review_path(shop, review)
        expect(response).to redirect_to login_url
      end
    end

    context "正しいユーザーでない場合" do
      before { log_in_as(other_user) }

      it "リクエストが成功する" do
        delete shop_review_path(shop, review)
        expect(response.status).to eq 302
      end

      it "rootページにリダイレクトする" do
        delete shop_review_path(shop, review)
        expect(response).to redirect_to root_url
      end
    end
  end
end
