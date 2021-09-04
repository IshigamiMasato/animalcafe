module SystemHelpers
  def log_in_as(user)
    visit login_path

    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password
    click_button "Log in"
  end
end
