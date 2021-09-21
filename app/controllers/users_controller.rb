class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :bookmarking]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  before_action :ensure_normal_user, only: :update

  def index
    @users = User.where(activated: true).paginate(page: params[:page], per_page: 20)
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    redirect_to root_url and return unless @user.activated?
    @shops = @user.shops.paginate(page: params[:page], per_page: 6)
  end

  def create
    @user = User.new(user_params)
    @user.avater.attach(params[:user][:avater])
    if @user.save
      @user.send_activation_email
      flash[:info] = "アカウント有効化メールを送信しました"
      redirect_to root_url
    else
      render "new"
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = "プロフィールを更新しました"
      redirect_to @user
    else
      render "edit"
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "ユーザーを削除しました"
    redirect_to users_url
  end

  def bookmarking
    @user = User.find(params[:id])
    @shops = @user.bookmarking.paginate(page: params[:page], per_page: 6)
  end

  private

  def user_params
    params.require(:user).permit(
      :name,
      :email,
      :password,
      :password_confirmation,
      :avater
    )
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def ensure_normal_user
    @user ||= User.find(params[:id])
    if @user.email == "guest_user@example.com"
      flash[:warning] = "ゲストユーザーはプロフィールを編集できません"
      redirect_to root_url
    end
  end
end
