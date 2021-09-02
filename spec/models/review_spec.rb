require 'rails_helper'

RSpec.describe Review, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  let(:shop) { FactoryBot.create(:shop, user: other_user) }
  let(:review) { FactoryBot.build(:review, user: user, shop: shop) }

  it "user_id、shop_id、評価点があれば有効である" do
    expect(review).to be_valid
  end

  it "user_idがなければ無効である" do
    review.user_id = ""
    expect(review).to_not be_valid
  end

  it "shop_idがなければ無効である" do
    review.shop_id = ""
    expect(review).to_not be_valid
  end

  it "評価点がなければ無効である" do
    review.score = ""
    expect(review).to_not be_valid
  end

  it "ユーザーが削除されたら、そのユーザーに紐づくクチコミの投稿は削除される" do
    review.save
    expect {
      user.destroy
    }.to change(Review, :count).by(-1)
  end

  it "店舗の投稿が削除されたら、その店舗に紐づくクチコミの投稿は削除される" do
    review.save
    expect {
      shop.destroy
    }.to change(Review, :count).by(-1)
  end

  it "コメントの長さが256文字以上は無効な状態であること" do
    review.content = "a" * 256
    review.valid?
    expect(review.errors[:content]).to include("は255文字以内で入力してください")
  end

  describe "クチコミの並び順のテスト" do
    let(:user) { FactoryBot.create(:user) }
    let(:other_user) { FactoryBot.create(:user) }
    let(:shop) { FactoryBot.create(:shop, user: other_user) }
    let!(:a_few_minutes_ago_review) { FactoryBot.create(:review, user: user, shop: shop) }
    let!(:yesterday_review) { FactoryBot.create(:review, :yesterday, user: user, shop: shop) }
    let!(:most_recent_review) { FactoryBot.create(:review, :most_recent_review, user: user, shop: shop) }

    it "クチコミを並べた時の一番上のクチコミは、一番最近のクチコミである" do
      expect(Review.first).to eq most_recent_review
    end
  end
end
