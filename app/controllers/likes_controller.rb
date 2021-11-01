class LikesController < ApplicationController
  before_action :logged_in_user

  def create
    @shop = Shop.find(params[:shop_id])
    current_user.like(@shop)
    respond_to do |format|
      format.html { redirect_to @shop }
      format.js
    end
  end

  def destroy
    @shop = Like.find(params[:id]).shop
    current_user.unlike(@shop)
    respond_to do |format|
      format.html { redirect_to @shop }
      format.js
    end
  end
end
