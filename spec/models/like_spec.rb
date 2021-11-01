require 'rails_helper'

RSpec.describe Like, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  let(:shop) { FactoryBot.create(:shop, user: other_user) }

  before do
    @like = Like.new(user_id: user.id, shop_id: shop.id)
  end

  it "userとshopがあれば有効である" do
    expect(@like).to be_valid
  end

  it "user_idがなければ無効である" do
    @like.user_id = nil
    expect(@like).to_not be_valid
  end

  it "shop_idがなければ無効である" do
    @like.shop_id = nil
    expect(@like).to_not be_valid
  end
end
