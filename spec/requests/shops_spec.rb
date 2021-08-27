require 'rails_helper'

RSpec.describe "Shops", type: :request do
  describe "GET /shops/new" do
    let!(:user) { FactoryBot.create(:user) }

    context "ログインしている場合" do
      before { log_in_as(user) }

      it "リクエストが成功する" do
        get new_shop_path
        expect(response.status).to eq 200
      end
    end

    context "ログインしていない場合" do
      it "リクエストが成功する" do
        get new_shop_path
        expect(response.status).to eq 302
      end
      it "loginページにリダイレクトする" do
        get new_shop_path
        expect(response).to redirect_to login_url
      end
    end
  end

  describe "POST /shops" do
    let!(:user) { FactoryBot.create(:user) }

    context "ログインしている場合" do
      before { log_in_as(user) }

      context "パラメータが有効な場合" do
        let(:shop_params) { FactoryBot.attributes_for(:shop, user: user) }

        it "リクエストが成功する" do
          post shops_path, params: { shop: shop_params }
          expect(response.status).to eq 302
        end

        it "店舗を投稿する" do
          expect {
            post shops_path, params: { shop: shop_params }
          }.to change(Shop, :count).by(1)
        end

        it "成功メッセージを表示する" do
          post shops_path, params: { shop: shop_params }
          follow_redirect!
          expect(response.body).to include "Shop created!"
        end

        it "店舗showページにリダイレクトする" do
          post shops_path, params: { shop: shop_params }
          shop = Shop.last
          expect(response).to redirect_to shop
        end
      end

      context "パラメータが無効な場合" do
        let(:invalid_shop_params) { FactoryBot.attributes_for(:invalid_shop, user: user) }

        it "リクエストが成功する" do
          post shops_path, params: { shop: invalid_shop_params }
          expect(response.status).to eq 200
        end

        it "店舗を投稿しない" do
          expect {
            post shops_path, params: { shop: invalid_shop_params }
          }.to change(Shop, :count).by(0)
        end
      end
    end

    context "ログインしていない場合" do
      let(:shop_params) { FactoryBot.attributes_for(:shop, user: user) }

      it "リクエストが成功する" do
        post shops_path, params: { shop: shop_params }
        expect(response.status).to eq 302
      end

      it "loginページにリダイレクトする" do
        post shops_path, params: { shop: shop_params }
        expect(response).to redirect_to login_url
      end

      it "店舗を投稿しない" do
        expect {
          post shops_path, params: { shop: shop_params }
        }.to change(Shop, :count).by(0)
      end

      it "エラーメッセージを表示する" do
        post shops_path, params: { shop: shop_params }
        follow_redirect!
        expect(response.body).to include "Please log in."
      end
    end
  end
end
