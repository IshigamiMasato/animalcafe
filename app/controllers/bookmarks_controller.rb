class BookmarksController < ApplicationController
  before_action :logged_in_user

  def create
    shop = Shop.find(params[:shop_id])
    current_user.bookmark(shop)
    redirect_to shop
  end

  def destroy
    shop = Bookmark.find(params[:id]).shop
    current_user.unbookmark(shop)
    redirect_to shop
  end
end
