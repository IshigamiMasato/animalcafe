require 'rails_helper'

RSpec.describe "HomeLayouts", type: :system do
  before { visit root_path }

  it "Homeに正しいリンクが表示されている" do
    expect(page).to have_link "ANIMAL CAFE"
    expect(page).to have_link "Home", count: 2
    expect(page).to have_link "What is an animal cafe?", count: 2
    expect(page).to have_link "Sign up now!"
  end

  it "ANIMAL CAFEリンクを押すと、Homeにページ遷移する" do
    click_link "ANIMAL CAFE"
    expect(current_path).to eq root_path
    expect(page).to have_title "ANIMAL CAFE"
  end

  it "Homeリンクを押すと、Homeページに遷移する" do
    click_link "Home", match: :first
    expect(current_path).to eq root_path
    expect(page).to have_title "ANIMAL CAFE"
  end

  it "What is an animal cafe?リンクを押すと、aboutページに遷移する" do
    click_link "What is an animal cafe?", match: :first
    expect(current_path).to eq about_path
    expect(page).to have_title "ABOUT | ANIMAL CAFE"
  end

  it "Sign up now!のリンクを押すと、signupページに遷移する" do
    click_link "Sign up now!"
    expect(current_path).to eq signup_path
    expect(page).to have_title "SIGN UP | ANIMAL CAFE"
  end

  describe "サイドバーのリンク" do
    it "Homeリンクを押すと、Homeページに遷移する" do
      page.all(:link, "Home")[1].click
      expect(current_path).to eq root_path
      expect(page).to have_title "ANIMAL CAFE"
    end

    it "What is an animal cafe?リンクを押すと、aboutページに遷移する" do
      page.all(:link, "What is an animal cafe?")[1].click
      expect(current_path).to eq about_path
      expect(page).to have_title "ABOUT | ANIMAL CAFE"
    end
  end
end
