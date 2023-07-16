require "rails_helper"

RSpec.describe Api::Webhooks::MessagesController, type: :request do
  describe "POST /api/webhooks/messages" do
    it "accepts data and returns accepted" do
      expect(Messages::ProcessCallbackService).to receive(:new).with(status: "delivered", message_id: "123").and_return(double(call: true))

      post "/api/webhooks/messages", params: { status: "delivered", message_orig_id: "123" }
      expect(response).to have_http_status(:accepted)
    end
  end
end
