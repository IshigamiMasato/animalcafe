require 'rails_helper'

RSpec.describe "Bookmarks", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  let(:shop) { FactoryBot.create(:shop, user: other_user) }

  describe "POST /bookmarks" do
    context "ログインしている場合" do
      before { log_in_as(user) }

      it "リクエストが成功する" do
        post bookmarks_path, params: { shop_id: shop.id }
        expect(response.status).to eq 302
      end
      it "ブックマークする" do
        expect {
          post bookmarks_path, params: { shop_id: shop.id }
        }.to change(Bookmark, :count).by(1)
      end
    end

    context "ログインしていない場合" do
      it "リクエストが成功する" do
        post bookmarks_path, params: { shop_id: shop.id }
        expect(response.status).to eq 302
      end

      it "ブックマークしない" do
        expect {
          post bookmarks_path, params: { shop_id: shop.id }
        }.to_not change(Bookmark, :count)
      end

      it "ログインページにリダイレクトする" do
        post bookmarks_path, params: { shop_id: shop.id }
        expect(response).to redirect_to login_url
      end
    end
  end

  describe "DELETE /bookmarks/:id" do
    before { user.bookmark(shop) }

    context "ログインしている場合" do
      before { log_in_as(user) }

      it "リクエストが成功する" do
        bookmark = user.bookmarks.last
        delete bookmark_path(bookmark)
        expect(response.status).to eq 302
      end

      it "ブックマークを削除する" do
        bookmark = user.bookmarks.last
        expect {
          delete bookmark_path(bookmark)
        }.to change(Bookmark, :count).by(-1)
      end
    end

    context "ログインしていない場合" do
      it "リクエストが成功する" do
        bookmark = user.bookmarks.last
        delete bookmark_path(bookmark)
        expect(response.status).to eq 302
      end

      it "ブックマークを削除しない" do
        bookmark = user.bookmarks.last
        expect {
          delete bookmark_path(bookmark)
        }.to_not change(Bookmark, :count)
      end

      it "ログインページにリダイレクトする" do
        bookmark = user.bookmarks.last
        delete bookmark_path(bookmark)
        expect(response).to redirect_to login_url
      end
    end
  end
end
