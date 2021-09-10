class BookmarksController < ApplicationController
  before_action :logged_in_user

  def create
    @shop = Shop.find(params[:shop_id])
    current_user.bookmark(@shop)
    respond_to do |format|
      format.html { redirect_to @shop }
      format.js
    end
  end

  def destroy
    @shop = Bookmark.find(params[:id]).shop
    current_user.unbookmark(@shop)
    respond_to do |format|
      format.html { redirect_to @shop }
      format.js
    end
  end
end
