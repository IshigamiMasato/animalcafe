require 'rails_helper'

RSpec.describe "ReviewsDisplay", type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:shop) { FactoryBot.create(:shop, user: user) }
  let!(:reviews) { FactoryBot.create_list(:review, 11, user: user, shop: shop) }

  it "店舗ページのクチコミの表示テスト" do
    visit shop_path(shop)
    expect(current_path).to eq shop_path(shop)
    expect(page).to have_content "クチコミ: 11件"
    # クチコミは最大10件表示される
    expect(page).to have_content reviews.first.content, count: 10
  end
end
