require 'rails_helper'

RSpec.describe "ShopsEdit", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:shop) { FactoryBot.create(:shop, user: user) }
  let(:other_user) { FactoryBot.create(:user) }
  let(:other_user_shop) { FactoryBot.create(:other_shop, user: other_user) }

  describe "GET /shops/:id/edit" do
    context "ログインしている場合" do
      before { log_in_as(user) }

      it "リクエストが成功する" do
        get edit_shop_path(shop)
        expect(response.status).to eq 200
      end

      it "店舗名が表示されている" do
        get edit_shop_path(shop)
        expect(response.body).to include shop.name
      end

      it "他ユーザーの店舗編集ページにアクセスせず、rootページにリダイレクトする" do
        get edit_shop_path(other_user_shop)
        expect(response).to redirect_to root_url
      end
    end

    context "ログインしていない場合" do
      it "リクエストが成功する" do
        get edit_shop_path(shop)
        expect(response.status).to eq 302
      end
      it "エラーメッセージを表示する" do
        get edit_shop_path(shop)
        follow_redirect!
        expect(response.body).to include "ログインして下さい"
      end
      it "loginページにリダイレクトする" do
        get edit_shop_path(shop)
        expect(response).to redirect_to login_url
      end
    end
  end

  describe "PATCH /shops/:id" do
    let(:edit_shop_params) { FactoryBot.attributes_for(:edit_shop_params) }

    context "ログインしている場合" do
      before { log_in_as(user) }

      it "リクエストが成功する" do
        patch shop_path(shop), params: { shop: edit_shop_params }
        expect(response.status).to eq 302
      end

      it "店舗名を更新する" do
        patch shop_path(shop), params: { shop: edit_shop_params }
        expect(shop.reload.name).to eq edit_shop_params[:name]
      end

      it "shopページにリダイレクトする" do
        patch shop_path(shop), params: { shop: edit_shop_params }
        expect(response).to redirect_to shop_path(shop)
      end

      it "他ユーザーのshop編集はせず、rootページにリダイレクトする" do
        patch shop_path(other_user_shop), params: { shop: edit_shop_params }
        expect(response).to redirect_to root_url
      end
    end

    context "ログインしていない場合" do
      it "リクエストが成功する" do
        patch shop_path(shop), params: { shop: edit_shop_params }
        expect(response.status).to eq 302
      end

      it "エラーメッセージを表示する" do
        patch shop_path(shop), params: { shop: edit_shop_params }
        follow_redirect!
        expect(response.body).to include "ログインして下さい"
      end

      it "loginページにリダイレクトする" do
        patch shop_path(shop), params: { shop: edit_shop_params }
        expect(response).to redirect_to login_url
      end
    end
  end
end
