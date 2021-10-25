class ShopsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]
  before_action :correct_shop_poster, only: [:edit, :update, :destroy]

  def index
    @shops = Shop.search(user_search_params).includes(:reviews, :user).paginate(page: params[:page], per_page: 6).with_attached_images
  end

  def new
    @shop = current_user.shops.build
  end

  def show
    @shop = Shop.find(params[:id])
    @tags = @shop.tags
    @review = Review.new
    @reviews = @shop.reviews.includes(:user)
  end

  def create
    @shop = current_user.shops.build(shop_params)
    animal_tags = params[:shop][:tag_animal].split(" ") if params[:shop][:tag_animal].present?
    env_tags = params[:shop][:tag_env].split(" ") if params[:shop][:tag_env].present?
    if @shop.save
      @shop.save_animal_tag(animal_tags) if animal_tags.present?
      @shop.save_env_tag(env_tags) if env_tags.present?
      flash[:success] = "店舗を投稿しました!"
      redirect_to @shop
    else
      render "new"
    end
  end

  def edit
  end

  def update
    animal_tags = params[:shop][:tag_animal].split(" ") if params[:shop][:tag_animal].present?
    env_tags = params[:shop][:tag_env].split(" ") if params[:shop][:tag_env].present?
    if @shop.update(shop_params)
      @shop.save_animal_tag(animal_tags) if animal_tags.present?
      @shop.save_env_tag(env_tags) if env_tags.present?
      flash[:success] = "店舗情報を更新しました"
      redirect_to @shop
    else
      render "edit"
    end
  end

  def destroy
    @shop.destroy
    flash[:success] = "店舗を削除しました"
    redirect_to @shop.user
  end

  def tag_search
    tag = Tag.find(params[:tag_id])
    @shops = tag.shops.paginate(page: params[:page], per_page: 6)
    render "index" and return
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
