require 'rails_helper'
include ApplicationHelper

RSpec.describe ApplicationHelper, type: :request do
  describe "#full_title(page_title)" do
    context "ページタイトルが空白の場合" do
      it "タイトルはANIMAL CAFE" do
        expect(full_title("")).to eq "ANIMAL CAFE"
      end
    end

    context "ページタイトルがnilの場合" do
      it "タイトルはANIMAL CAFE" do
        expect(full_title(nil)).to eq "ANIMAL CAFE"
      end
    end

    context "ページタイトルがsampleの場合" do
      it "タイトルは sample | ANIMAL CAFE" do
        expect(full_title("sample")).to eq "sample | ANIMAL CAFE"
      end
    end
  end
end
