require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  describe "GET /" do
    it "リクエストが成功する" do
      get root_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /about" do
    it "リクエストが成功する" do
      get about_path
      expect(response).to have_http_status(:success)
    end
  end
end