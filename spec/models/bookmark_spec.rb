require 'rails_helper'

RSpec.describe Bookmark, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  let(:shop) { FactoryBot.create(:shop, user: other_user) }

  before do
    @bookmark = Bookmark.new(user_id: user.id, shop_id: shop.id)
  end

  it "user_idとshop_idがあれば有効である" do
    expect(@bookmark).to be_valid
  end

  it "user_idがなければ無効である" do
    @bookmark.user_id = nil
    expect(@bookmark).to_not be_valid
  end

  it "shop_idがなければ無効である" do
    @bookmark.shop_id = nil
    expect(@bookmark).to_not be_valid
  end
end
