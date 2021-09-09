class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in(user)
        params[:session][:remember_me] == "1" ? remember(user) : forget(user)
        flash[:success] = "ログインしました"
        redirect_back_or(shops_url)
      else
        message = "アカウントが有効化されていません、"
        message += "emailに送られた有効化リンクを確認して下さい"
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = "メールアドレスかパスワードが違います"
      render "new"
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  def guest_login
    user = User.guest
    log_in(user)
    flash[:success] = "ゲストユーザーとしてログインしました"
    redirect_to shops_url
  end
end
