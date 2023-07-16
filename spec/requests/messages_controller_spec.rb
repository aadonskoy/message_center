require "rails_helper"

RSpec.describe MessagesController, type: :request do
  describe "GET /messages" do
    before do
      create_list(:message, 2, phone_number: "1234567890")
      create(:message, phone_number: "5432145678")
    end

    it "returns 200" do
      get "/messages"
      expect(response).to have_http_status(:success)
      expect(response.body).to include("1234567890", "5432145678")
    end

    it "seaches by phone number" do
      get "/messages", params: { phone_number: "543" }
      expect(response).to have_http_status(:success)
      expect(response.body).to include("5432145678")
      expect(response.body).not_to include("1234567890")
    end
  end
end
