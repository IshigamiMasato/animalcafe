require 'rails_helper'

RSpec.describe TagMap, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:shop) { FactoryBot.create(:shop, user: user) }
  let(:tag) { FactoryBot.create(:tag) }
  let(:tag_map) { FactoryBot.build(:tag_map, shop: shop, tag: tag) }

  it "shop_id, tag_idがあれば有効である" do
    expect(tag_map).to be_valid
  end

  it "shop_idが無ければ無効である" do
    tag_map.shop_id = ""
    expect(tag_map).to_not be_valid
  end

  it "tag_idが無ければ無効である" do
    tag_map.tag_id = ""
    expect(tag_map).to_not be_valid
  end

  it "shopが削除されたら、そのshopに紐づくtag_mapは削除される" do
    tag_map.save
    expect {
      shop.destroy
    }.to change(TagMap, :count).by(-1)
  end

  it "tagが削除されたら、そのtagに紐づくtag_mapは削除される" do
    tag_map.save
    expect {
      tag.destroy
    }.to change(TagMap, :count).by(-1)
  end
end
