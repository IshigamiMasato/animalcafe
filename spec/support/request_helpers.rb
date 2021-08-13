module RequestHelpers
  def is_logged_in?
    !session[:user_id].nil?
  end

  # テストユーザーとしてログインする
  def log_in_as(user, password: "foobar", remember_me: "1")
    post login_path, params: {
      session: {
        email: user.email,
        password: password,
        remember_me: remember_me,
      },
    }
  end
end
