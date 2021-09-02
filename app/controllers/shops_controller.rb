class ShopsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]
  before_action :correct_shop_poster, only: [:edit, :update, :destroy]

  def index
    @shops = Shop.search(user_search_params)
  end

  def new
    @shop = current_user.shops.build
  end

  def show
    @shop = Shop.find(params[:id])
    @review = Review.new
    @reviews = @shop.reviews
  end

  def create
    @shop = current_user.shops.build(shop_params)
    if @shop.save
      flash[:success] = "Shop created!"
      redirect_to @shop
    else
      render "new"
    end
  end

  def edit
  end

  def update
    if @shop.update(shop_params)
      flash[:success] = "Shop updated"
      redirect_to @shop
    else
      render "edit"
    end
  end

  def destroy
    @shop.destroy
    flash[:success] = "Shop deleted"
    redirect_to @shop.user
  end

  private

  def shop_params
    params.require(:shop).permit(
      :name,
      :started_at,
      :closed_at,
      :regular_holiday,
      :phone_number,
      :address,
      :low_budget,
      :high_budget,
      :description,
      :nearest_station,
      images: []
    )
  end

  def user_search_params
    params.fetch(:search, {}).permit(:address)
  end

  def correct_shop_poster
    @shop = current_user.shops.find_by(id: params[:id])
    redirect_to root_url if @shop.nil?
  end
end
