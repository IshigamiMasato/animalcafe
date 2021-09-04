require 'rails_helper'

RSpec.describe "PasswordReset", type: :system do
  let!(:user) { FactoryBot.create(:user) }

  it "パスワード再設定(email送信まで)" do
    visit root_path
    expect(current_path).to eq root_path

    click_link "Log in", match: :first
    expect(current_path).to eq login_path
    click_link "(パスワードをお忘れですか？)"
    expect(current_path).to eq new_password_reset_path

    # 無効なメールアドレスを送信
    fill_in "メールアドレス", with: ""
    click_button "Submit"

    expect(page).to have_selector "div.alert-danger"

    # 有効なメールアドレスを送信
    fill_in "メールアドレス", with: user.email
    click_button "Submit"

    expect(page).to have_selector "div.alert-info"
    expect(current_path).to eq root_path
  end
end
