require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  describe "GET /" do
    it "リクエストが成功する" do
      get root_path
      expect(response.status).to eq 200
    end
  end

  describe "GET /about" do
    it "リクエストが成功する" do
      get about_path
      expect(response.status).to eq 200
    end
  end
end
