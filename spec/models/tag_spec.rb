require 'rails_helper'

RSpec.describe Tag, type: :model do
  let(:tag) { FactoryBot.build(:tag) }

  it "名前と属性があれば有効であること" do
    expect(tag).to be_valid
  end

  it "名前がなければ無効であること" do
    tag.name = ""
    expect(tag).to_not be_valid
  end

  it "属性がなければ無効であること" do
    tag.tag_type = ""
    expect(tag).to_not be_valid
  end

  it "名前の長さが16文字以上は無効な状態であること" do
    tag.name = "a" * 16
    tag.valid?
    expect(tag.errors[:name]).to include("は15文字以内で入力してください")
  end
end
