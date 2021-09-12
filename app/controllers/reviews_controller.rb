class ReviewsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_review_user, only: :destroy

  def create
    @review = Review.new(review_params)
    @review.user_id = current_user.id
    if @review.save
      flash[:success] = "クチコミを投稿しました!"
      redirect_to @review.shop
    else
      @shop = Shop.find(params[:shop_id])
      @reviews = @shop.reviews
      @tags = @shop.tags
      render "shops/show"
    end
  end

  def destroy
    @review.destroy
    flash[:success] = "クチコミを削除しました"
    redirect_to @review.shop
  end

  private

  def review_params
    params.require(:review).permit(
      :shop_id,
      :score,
      :content
    )
  end

  def correct_review_user
    @review = current_user.reviews.find_by(id: params[:id])
    redirect_to root_url if @review.nil?
  end
end
