require 'rails_helper'

RSpec.describe "ShopsDelete", type: :request do
  describe "DELETE /shops/:id" do
    let(:user) { FactoryBot.create(:user) }
    let(:other_user) { FactoryBot.create(:user) }
    let!(:shop) { FactoryBot.create(:shop, user: user) }

    context "ログインしている場合" do
      it "リクエストが成功する" do
        log_in_as(user)
        delete shop_path(shop)
        expect(response.status).to eq 302
      end

      it "店舗を削除する" do
        log_in_as(user)
        expect {
          delete shop_path(shop)
        }.to change(Shop, :count).by(-1)
      end

      it "profileページにリダイレクトする" do
        log_in_as(user)
        delete shop_path(shop)
        expect(response).to redirect_to user
      end

      it "成功メッセージを表示する" do
        log_in_as(user)
        delete shop_path(shop)
        follow_redirect!
        expect(response.body).to include "店舗を削除しました"
      end

      it "他ユーザーの店舗投稿を消去せず、rootページにリダイレクトする" do
        log_in_as(other_user)
        expect {
          delete shop_path(shop)
        }.to_not change(Shop, :count)
        expect(response).to redirect_to root_url
      end
    end

    context "ログインしていない場合" do
      it "リクエストが成功する" do
        delete shop_path(shop)
        expect(response.status).to eq 302
      end

      it "loginページにリダイレクトする" do
        delete shop_path(shop)
        expect(response).to redirect_to login_url
      end
    end
  end
end
