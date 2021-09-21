require 'rails_helper'

RSpec.describe "SiteLayouts", type: :system do
  describe "ヘッダーとサイドバーのレイアウト" do
    context "ログインしていない場合" do
      before { visit root_path }

      it "ヘッダーとサイドバーに正しいリンクを表示する" do
        expect(page).to have_link "ANIMAL CAFE"
        expect(page).to have_link "animal cafe とは?"
        expect(page).to have_link href: login_path, count: 2
        expect(page).to have_link href: signup_path, count: 2
      end

      it "What is an animal cafe?リンクを押すと、aboutページに遷移する" do
        click_link "animal cafe とは?"
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

          it "ログインリンクを押すと、loginページに遷移する" do
            click_link "ログイン", match: :first
            expect(current_path).to eq login_path
            expect(page).to have_title "Log in | ANIMAL CAFE"
          end

          it "新規登録のリンクを押すと、signupページに遷移する" do
            click_link "新規登録", match: :first
            expect(current_path).to eq signup_path
            expect(page).to have_title "Sign up | ANIMAL CAFE"
          end
        end

        describe "サイドバーのリンク" do
          it "ログインリンクを押すと、loginページに遷移する" do
            page.all(:link, "ログイン")[1].click
            expect(current_path).to eq login_path
            expect(page).to have_title "Log in | ANIMAL CAFE"
          end

          it "新規登録のリンクを押すと、signupページに遷移する" do
            page.all(:link, "新規登録")[1].click
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
          expect(page).to have_link href: user_path(user), count: 2
          expect(page).to have_link href: logout_path, count: 2
          expect(page).to have_link href: new_shop_path, count: 2
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

            it "ログアウトリンクを押すと、Homeページに遷移する" do
              click_link "ログアウト", match: :first
              expect(current_path).to eq root_path
              expect(page).to have_title "ANIMAL CAFE"
            end

            it "投稿を押すと、shop投稿ページに遷移する" do
              click_link "投稿", match: :first
              expect(current_path).to eq new_shop_path
              expect(page).to have_title "Post shop | ANIMAL CAFE"
            end
          end

          describe "サイドバーのリンク" do
            it "プロフィールリンクを押すと、profileページに遷移する" do
              click_link "プロフィール"
              expect(current_path).to eq user_path(user)
              expect(page).to have_title "#{user.name} | ANIMAL CAFE"
            end

            it "ログアウトリンクを押すと、Homeページに遷移する" do
              page.all(:link, "ログアウト")[1].click
              expect(current_path).to eq root_path
              expect(page).to have_title "ANIMAL CAFE"
            end

            it "投稿リンクを押すと、shop投稿ページに遷移する" do
              page.all(:link, "投稿")[1].click
              expect(current_path).to eq new_shop_path
              expect(page).to have_title "Post shop | ANIMAL CAFE"
            end
          end
        end
      end

      describe "profileページのレイアウト" do
        it "profileページに正しいリンクを表示する" do
          expect(current_path).to eq shops_path
          find(".user_icon").click
          expect(current_path).to eq user_path(user)
          expect(page).to have_link "プロフィール編集"
          expect(page).to have_link "過去の投稿"
          expect(page).to have_link "ブックマーク"
        end

        describe "画面遷移" do
          it "プロフィール編集リンクを押すと、profileページに遷移する" do
            expect(current_path).to eq shops_path
            find(".user_icon").click
            expect(current_path).to eq user_path(user)
            click_link "プロフィール編集"
            expect(current_path).to eq edit_user_path(user)
            expect(page).to have_title "Edit user | ANIMAL CAFE"
          end

          it "過去の投稿リンクを押すと、profileページに遷移する" do
            expect(current_path).to eq shops_path
            find(".user_icon").click
            expect(current_path).to eq user_path(user)
            click_link "過去の投稿"
            expect(current_path).to eq user_path(user)
            expect(page).to have_title "#{user.name} | ANIMAL CAFE"
          end

          it "ブックマークリンクを押すと、ブックマークページに遷移する" do
            expect(current_path).to eq shops_path
            find(".user_icon").click
            expect(current_path).to eq user_path(user)
            click_link "ブックマーク"
            expect(current_path).to eq bookmarking_user_path(user)
            expect(page).to have_title "Bookmark shops | ANIMAL CAFE"
          end
        end
      end
    end
  end
end
