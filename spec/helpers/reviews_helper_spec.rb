require 'rails_helper'

RSpec.describe ReviewsHelper, type: :helper do
  describe "#score_percentage(score)" do
    it "1つのクチコミの点数の100分率を返す" do
      expect(score_percentage(1)).to eq 20.0
      expect(score_percentage(2)).to eq 40.0
      expect(score_percentage(3)).to eq 60.0
      expect(score_percentage(4)).to eq 80.0
      expect(score_percentage(5)).to eq 100.0
    end
  end
end
