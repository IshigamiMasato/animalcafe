require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.build(:user) }

  it "名前、メールアドレスがあれば有効であること" do
    expect(user).to be_valid
  end

  it "名前がなければ無効な状態であること" do
    user.name = ""
    user.valid?
    expect(user.errors[:name]).to include("を入力してください")
  end

  it "メールアドレスがなければ無効な状態であること" do
    user.email = ""
    user.valid?
    expect(user.errors[:email]).to include("を入力してください")
  end

  it "名前の長さが51文字以上は無効な状態であること" do
    user.name = "a" * 51
    user.valid?
    expect(user.errors[:name]).to include("は50文字以内で入力してください")
  end

  it "メールアドレスの長さが256文字以上は無効な状態であること" do
    user.email = "a" * 244 + "@example.com"
    user.valid?
    expect(user.errors[:email]).to include("は255文字以内で入力してください")
  end

  it "重複したメールアドレスなら無効な状態であること" do
    user.save
    duplicate_user = user.dup
    duplicate_user.email = user.email.upcase
    duplicate_user.save
    expect(duplicate_user.errors[:email]).to include("はすでに存在します")
  end

  it "メールアドレスはデータベースに登録される際に、小文字の状態で登録される" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    user.email = mixed_case_email
    user.save
    expect(user.reload.email).to eq mixed_case_email.downcase
  end

  it "パスワードがなければ無効な状態であること" do
    user.password = user.password_confirmation = " " * 6
    user.valid?
    expect(user.errors[:password]).to include("を入力してください")
  end

  it "パスワードが5文字以下は無効な状態であること" do
    user.password = user.password_confirmation = "a" * 5
    user.valid?
    expect(user.errors[:password]).to include("は6文字以上で入力してください")
  end

  describe "メールフォーマット" do
    it "正しいフォーマットのメールアドレスは有効であること" do
      valid_addresses = %w(
        user@example.com
        USER@foo.COM
        A_US-ER@foo.bar.org
        first.last@foo.jp
        alice+bob@baz.cn
      )
      valid_addresses.each do |valid_address|
        user.email = valid_address
        expect(user).to be_valid
      end
    end

    it "不正なフォーマットのメールアドレスは無効であること" do
      invalid_addresses = %w(
        user@example,com
        user_at_foo.org
        user.name@example.
        foo@bar_baz.com
        foo@bar+baz.com
        foo@bar..com
      )
      invalid_addresses.each do |invalid_address|
        user.email = invalid_address
        expect(user).to_not be_valid
      end
    end
  end

  it "authenticated?メソッドは、remember_digestがnilならfalseを返す" do
    expect(user.authenticated?(:remember, "")).to eq false
  end
end
