class ShopsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create]

  def new
    @shop = current_user.shops.build
  end

  def show
    @shop = Shop.find(params[:id])
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
end
