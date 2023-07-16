require "rails_helper"

RSpec.describe Api::MessagesController, type: :request do
  describe "POST /api/messages" do
    context "with correct params" do
      before do
        expect(Messages::SendJob).to receive(:perform_later).and_return(true)
      end

      it "returns 200" do
        expect {
          post "/api/messages", params: { message: { text: "Test", phone_number: "1234567890" } }
        }.to change(Message, :count).by(1)

        expect(response).to have_http_status(:success)
      end
    end

    context "with incorrect params" do
      it "returns 422 with explanations" do
        expect {
          post "/api/messages", params: { message: { text: "", phone_number: "" } }
        }.not_to change(Message, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body)
          .to eq("{\"errors\":{\"text\":[\"can't be blank\"],\"phone_number\":[\"can't be blank\"]}}")
      end
    end
  end
end
