class ReviewsController < ApplicationController
  before_action :logged_in_user, only: [:create]

  def create
    @review = Review.new(review_params)
    @review.user_id = current_user.id
    if @review.save
      redirect_to @review.shop
    else
      @shop = Shop.find(params[:shop_id])
      @reviews = @shop.reviews
      render "shops/show"
    end
  end

  private

  def review_params
    params.require(:review).permit(
      :shop_id,
      :score,
      :content
    )
  end
end
