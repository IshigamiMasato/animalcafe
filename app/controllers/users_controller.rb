class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    @user.avater.attach(params[:user][:avater])
    if @user.save
      log_in @user
      flash[:success] = "Welcom to the ANIMAL CAFE!"
      redirect_to @user
    else
      render "new"
    end
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
end
