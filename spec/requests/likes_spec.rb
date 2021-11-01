require 'rails_helper'

RSpec.describe "Likes", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  let(:shop) { FactoryBot.create(:shop, user: other_user) }

  describe "POST /likes" do
    context "ログインしている場合" do
      before { log_in_as(user) }

      it "リクエストが成功する" do
        post likes_path, params: { shop_id: shop.id }
        expect(response.status).to eq 302
      end

      it "いいねする" do
        expect {
          post likes_path, params: { shop_id: shop.id }
        }.to change(Like, :count).by(1)
      end
    end

    context "ログインしていない場合" do
      it "リクエストが成功する" do
        post likes_path, params: { shop_id: shop.id }
        expect(response.status).to eq 302
      end

      it "いいねしない" do
        expect {
          post likes_path, params: { shop_id: shop.id }
        }.to_not change(Like, :count)
      end

      it "ログインページにリダイレクトする" do
        post likes_path, params: { shop_id: shop.id }
        expect(response).to redirect_to login_url
      end
    end
  end

  describe "DELETE /likes/:id" do
    before { user.like(shop) }

    context "ログインしている場合" do
      before { log_in_as(user) }

      it "リクエストが成功する" do
        like = user.likes.last
        delete like_path(like)
        expect(response.status).to eq 302
      end

      it "いいねを削除する" do
        like = user.likes.last
        expect {
          delete like_path(like)
        }.to change(Like, :count).by(-1)
      end
    end

    context "ログインしていない場合" do
      it "リクエストが成功する" do
        like = user.likes.last
        delete like_path(shop)
        expect(response.status).to eq 302
      end

      it "いいねを削除しない" do
        like = user.likes.last
        expect {
          delete like_path(shop)
        }.to_not change(Like, :count)
      end

      it "ログインページにリダイレクトする" do
        like = user.likes.last
        delete like_path(shop)
        expect(response).to redirect_to login_url
      end
    end
  end
end
