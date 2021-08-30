require 'rails_helper'

RSpec.describe "SearchShops", type: :request do
  describe "GET /shops" do
    it "リクエストが成功する" do
      get shops_path, params: { search: { address: "" } }
      expect(response.status).to eq 200
    end

    it "paramsがnilの場合、空の配列を返す" do
      get shops_path, params: { search: { address: nil } }
      expect(response.body).to include "検索結果: 0件"
    end

    it "search以外のparamsを送信すると、空の配列を返す" do
      get shops_path, params: { area: { address: "" } }
      expect(response.body).to include "検索結果: 0件"
    end
  end
end
