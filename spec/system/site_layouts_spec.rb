require 'rails_helper'

RSpec.describe "SiteLayouts", type: :system do
  context "ゲストユーザーの場合" do
    before { visit root_path }

    scenario "Homeに正しいリンクが表示されている" do
      expect(page).to have_link "ANIMAL CAFE"
      expect(page).to have_link "What is an animal cafe?", count: 2
      expect(page).to have_link "Log in", count: 2
      expect(page).to have_link "Sign up now!"
    end

    scenario "Sign up now!のリンクを押すと、signupページに遷移する" do
      click_link "Sign up now!"
      expect(current_path).to eq signup_path
      expect(page).to have_title "Sign up | ANIMAL CAFE"
    end

    describe "ヘッダーのリンク" do
      scenario "ANIMAL CAFEリンクを押すと、Homeにページ遷移する" do
        click_link "ANIMAL CAFE"
        expect(current_path).to eq root_path
        expect(page).to have_title "ANIMAL CAFE"
      end

      scenario "What is an animal cafe?リンクを押すと、aboutページに遷移する" do
        click_link "What is an animal cafe?", match: :first
        expect(current_path).to eq about_path
        expect(page).to have_title "About | ANIMAL CAFE"
      end

      scenario "Log inリンクを押すと、loginページに遷移する" do
        click_link "Log in", match: :first
        expect(current_path).to eq login_path
        expect(page).to have_title "Log in | ANIMAL CAFE"
      end
    end

    describe "サイドバーのリンク" do
      scenario "What is an animal cafe?リンクを押すと、aboutページに遷移する" do
        page.all(:link, "What is an animal cafe?")[1].click
        expect(current_path).to eq about_path
        expect(page).to have_title "About | ANIMAL CAFE"
      end

      scenario "Log inリンクを押すと、loginページに遷移する" do
        page.all(:link, "Log in")[1].click
        expect(current_path).to eq login_path
        expect(page).to have_title "Log in | ANIMAL CAFE"
      end
    end
  end

  context "ログインユーザーの場合" do
    let!(:user) { FactoryBot.create(:user) }

    before do
      visit login_path

      fill_in "Email", with: "user@test.com"
      fill_in "Password", with: "foobar"
      click_button "Log in"
    end

    scenario "Homeに正しいリンクが表示されている" do
      expect(current_path).to eq user_path(user)
      expect(page).to have_link "ANIMAL CAFE"
      expect(page).to have_link "Users", count: 2
      expect(page).to have_link href: user_path(user)
      expect(page).to have_link "Profile"
      expect(page).to have_link "Log out", count: 2
    end

    describe "ヘッダーのリンク" do
      scenario "ANIMAL CAFEリンクを押すと、Homeページに遷移する" do
        click_link "ANIMAL CAFE"
        expect(current_path).to eq root_path
        expect(page).to have_title "ANIMAL CAFE"
      end

      scenario "ユーザーアイコンを押すと、profileページに遷移する" do
        find(".user_icon").click
        expect(current_path).to eq user_path(user)
        expect(page).to have_title "#{User.last.name} | ANIMAL CAFE"
      end

      scenario "Log outリンクを押すと、Homeページに遷移する" do
        click_link "Log out", match: :first
        expect(current_path).to eq root_path
        expect(page).to have_title "ANIMAL CAFE"
      end
    end

    describe "サイドバーのリンク" do
      scenario "Profileリンクを押すと、profileページに遷移する" do
        click_link "Profile"
        expect(current_path).to eq user_path(user)
        expect(page).to have_title "#{User.last.name} | ANIMAL CAFE"
      end

      scenario "Log outリンクを押すと、Homeページに遷移する" do
        page.all(:link, "Log out")[1].click
        expect(current_path).to eq root_path
        expect(page).to have_title "ANIMAL CAFE"
      end
    end
  end
end
