class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in(user)
        params[:session][:remember_me] == "1" ? remember(user) : forget(user)
        redirect_back_or(shops_url)
      else
        message = "Account not activated."
        message += "Check your email for the activaiton link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = "invalid email/password combination"
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
    flash[:success] = "login as a test user"
    redirect_to shops_url
  end
end
