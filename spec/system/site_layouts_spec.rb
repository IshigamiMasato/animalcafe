require 'rails_helper'

RSpec.describe "SiteLayouts", type: :system do
  describe "ヘッダーとサイドバーのレイアウト" do
    context "ゲストユーザーの場合" do
      before { visit root_path }

      scenario "ヘッダーとサイドバーに正しいリンクが表示されている" do
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

      describe "画面遷移" do
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
    end

    context "ログインユーザーの場合" do
      let!(:user) { FactoryBot.create(:user) }

      before { log_in_as(user) }

      describe "ヘッダーとサイドバーのレイアウト" do
        scenario "ヘッダーとサイドバーに正しいリンクが表示されている" do
          expect(page).to have_link "ANIMAL CAFE"
          expect(page).to have_link "Users", count: 2
          expect(page).to have_link href: user_path(user)
          expect(page).to have_link "Profile"
          expect(page).to have_link "Log out", count: 2
        end

        describe "画面遷移" do
          describe "ヘッダーのリンク" do
            scenario "ANIMAL CAFEリンクを押すと、Homeページに遷移する" do
              click_link "ANIMAL CAFE"
              expect(current_path).to eq root_path
              expect(page).to have_title "ANIMAL CAFE"
            end

            scenario "ユーザーアイコンを押すと、profileページに遷移する" do
              find(".user_icon").click
              expect(current_path).to eq user_path(user)
              expect(page).to have_title "#{user.name} | ANIMAL CAFE"
            end

            scenario "Log outリンクを押すと、Homeページに遷移する" do
              click_link "Log out", match: :first
              expect(current_path).to eq root_path
              expect(page).to have_title "ANIMAL CAFE"
            end

            scenario "usersリンクを押すと、ユーザーindexページに遷移する" do
              click_link "Users", match: :first
              expect(current_path).to eq users_path
              expect(page).to have_title "All users | ANIMAL CAFE"
            end
          end

          describe "サイドバーのリンク" do
            scenario "Profileリンクを押すと、profileページに遷移する" do
              click_link "Profile"
              expect(current_path).to eq user_path(user)
              expect(page).to have_title "#{user.name} | ANIMAL CAFE"
            end

            scenario "Log outリンクを押すと、Homeページに遷移する" do
              page.all(:link, "Log out")[1].click
              expect(current_path).to eq root_path
              expect(page).to have_title "ANIMAL CAFE"
            end

            scenario "usersリンクを押すと、ユーザーindexページに遷移する" do
              page.all(:link, "Users")[1].click
              expect(current_path).to eq users_path
              expect(page).to have_title "All users | ANIMAL CAFE"
            end
          end
        end
      end

      describe "profileページのレイアウト" do
        scenario "profileページに正しいリンクが表示されている" do
          expect(current_path).to eq user_path(user)
          expect(page).to have_link "プロフィール編集"
          expect(page).to have_link "過去の投稿"
          expect(page).to have_link "ピンした投稿"
        end

        describe "画面遷移" do
          scenario "プロフィール編集リンクを押すと、profileページに遷移する" do
            click_link "プロフィール編集"
            expect(current_path).to eq edit_user_path(user)
            expect(page).to have_title "Edit user | ANIMAL CAFE"
          end

          scenario "過去の投稿リンクを押すと、そのページに遷移する" do
            # 投稿機能実装後
          end

          scenario "ピンした投稿リンクを押すと、そのページに遷移する" do
            # ピン機能実装後
          end
        end
      end
    end
  end
end
