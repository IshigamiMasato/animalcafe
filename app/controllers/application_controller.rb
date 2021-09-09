class ApplicationController < ActionController::Base
  include SessionsHelper

  private

  # ユーザーのログインを確認する
  def logged_in_user
    unless logged_in?
      store_location # GETメソッドのリクエストURLをsessionに保存
      flash[:danger] = "ログインして下さい"
      redirect_to login_url
    end
  end
end
