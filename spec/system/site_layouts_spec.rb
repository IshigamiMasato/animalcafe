require 'rails_helper'

RSpec.describe "SiteLayouts", type: :system do
  describe "ヘッダーとサイドバーのレイアウト" do
    context "ログインしていない場合" do
      before { visit root_path }

      it "ヘッダーとサイドバーに正しいリンクを表示する" do
        expect(page).to have_link "ANIMAL CAFE"
        expect(page).to have_link "What is an animal cafe?"
        expect(page).to have_link "Log in", count: 2
        expect(page).to have_link "Sign up now!", count: 2
      end

      it "What is an animal cafe?リンクを押すと、aboutページに遷移する" do
        click_link "What is an animal cafe?"
        expect(current_path).to eq about_path
        expect(page).to have_title "About | ANIMAL CAFE"
      end

      describe "画面遷移" do
        describe "ヘッダーのリンク" do
          it "ANIMAL CAFEリンクを押すと、Homeにページ遷移する" do
            click_link "ANIMAL CAFE"
            expect(current_path).to eq root_path
            expect(page).to have_title "ANIMAL CAFE"
          end

          it "Log inリンクを押すと、loginページに遷移する" do
            click_link "Log in", match: :first
            expect(current_path).to eq login_path
            expect(page).to have_title "Log in | ANIMAL CAFE"
          end

          it "Sign up now!のリンクを押すと、signupページに遷移する" do
            click_link "Sign up now!", match: :first
            expect(current_path).to eq signup_path
            expect(page).to have_title "Sign up | ANIMAL CAFE"
          end
        end

        describe "サイドバーのリンク" do
          it "Log inリンクを押すと、loginページに遷移する" do
            page.all(:link, "Log in")[1].click
            expect(current_path).to eq login_path
            expect(page).to have_title "Log in | ANIMAL CAFE"
          end

          it "Sign up now!のリンクを押すと、signupページに遷移する" do
            page.all(:link, "Sign up now!")[1].click
            expect(current_path).to eq signup_path
            expect(page).to have_title "Sign up | ANIMAL CAFE"
          end
        end
      end
    end

    context "ログインユーザーの場合" do
      let!(:user) { FactoryBot.create(:user) }

      before { log_in_as(user) }

      describe "ヘッダーとサイドバーのレイアウト" do
        it "ヘッダーとサイドバーに正しいリンクを表示する" do
          expect(page).to have_link "ANIMAL CAFE"
          expect(page).to have_link "Users", count: 2
          expect(page).to have_link href: user_path(user), count: 2
          expect(page).to have_link "Log out", count: 2
          expect(page).to have_link href: new_shop_path
          expect(page).to have_link "New post"
        end

        describe "画面遷移" do
          describe "ヘッダーのリンク" do
            it "ANIMAL CAFEリンクを押すと、Homeページに遷移する" do
              click_link "ANIMAL CAFE"
              expect(current_path).to eq root_path
              expect(page).to have_title "ANIMAL CAFE"
            end

            it "ユーザーアイコンを押すと、profileページに遷移する" do
              find(".user_icon").click
              expect(current_path).to eq user_path(user)
              expect(page).to have_title "#{user.name} | ANIMAL CAFE"
            end

            it "Log outリンクを押すと、Homeページに遷移する" do
              click_link "Log out", match: :first
              expect(current_path).to eq root_path
              expect(page).to have_title "ANIMAL CAFE"
            end

            it "usersリンクを押すと、ユーザーindexページに遷移する" do
              click_link "Users", match: :first
              expect(current_path).to eq users_path
              expect(page).to have_title "All users | ANIMAL CAFE"
            end

            it "+Postリンクを押すと、shop投稿ページに遷移する" do
              find(".post_shop_icon").click
              expect(current_path).to eq new_shop_path
              expect(page).to have_title "Post shop | ANIMAL CAFE"
            end
          end

          describe "サイドバーのリンク" do
            it "Profileリンクを押すと、profileページに遷移する" do
              click_link "Profile"
              expect(current_path).to eq user_path(user)
              expect(page).to have_title "#{user.name} | ANIMAL CAFE"
            end

            it "Log outリンクを押すと、Homeページに遷移する" do
              page.all(:link, "Log out")[1].click
              expect(current_path).to eq root_path
              expect(page).to have_title "ANIMAL CAFE"
            end

            it "usersリンクを押すと、ユーザーindexページに遷移する" do
              page.all(:link, "Users")[1].click
              expect(current_path).to eq users_path
              expect(page).to have_title "All users | ANIMAL CAFE"
            end

            it "New postリンクを押すと、shop投稿ページに遷移する" do
              click_link "New post"
              expect(current_path).to eq new_shop_path
              expect(page).to have_title "Post shop | ANIMAL CAFE"
            end
          end
        end
      end

      describe "profileページのレイアウト" do
        it "profileページに正しいリンクを表示する" do
          expect(current_path).to eq user_path(user)
          expect(page).to have_link "プロフィール編集"
          expect(page).to have_link "過去の投稿"
          expect(page).to have_link "ピンした投稿"
        end

        describe "画面遷移" do
          it "プロフィール編集リンクを押すと、profileページに遷移する" do
            click_link "プロフィール編集"
            expect(current_path).to eq edit_user_path(user)
            expect(page).to have_title "Edit user | ANIMAL CAFE"
          end

          it "過去の投稿リンクを押すと、そのページに遷移する"
          it "ピンした投稿リンクを押すと、そのページに遷移する"
        end
      end
    end
  end
end
