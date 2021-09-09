require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "#account_activation(user)" do
    let(:user) { FactoryBot.create(:user) }

    before do
      user.activation_token = User.new_token
      @mail = UserMailer.account_activation(user)
    end

    it "ヘッダー部分" do
      expect(@mail.subject).to eq("アカウント有効化")
      expect(@mail.to).to eq([user.email])
      expect(@mail.from).to eq(["noreply@animalcafe.com"])
    end

    it "メール本文" do
      expect(@mail.body.encoded).to match(user.name)
      expect(@mail.body.encoded).to match(user.activation_token)
      expect(@mail.body.encoded).to match(CGI.escape(user.email))
    end
  end

  describe "#password_reset(user)" do
    let(:user) { FactoryBot.create(:user) }

    before do
      user.reset_token = User.new_token
      @mail = UserMailer.password_reset(user)
    end

    it "ヘッダー部分" do
      expect(@mail.subject).to eq("パスワード変更")
      expect(@mail.to).to eq([user.email])
      expect(@mail.from).to eq(["noreply@animalcafe.com"])
    end

    it "メール本文" do
      expect(@mail.body.encoded).to match(user.reset_token)
      expect(@mail.body.encoded).to match(CGI.escape(user.email))
    end
  end
end
