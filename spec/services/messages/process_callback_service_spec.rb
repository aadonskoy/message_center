require "rails_helper"

RSpec.describe Messages::ProcessCallbackService do
  describe "#call" do
    subject(:service) { described_class.new(status: status, message_id: message.reload.public_id) }

    let(:message) { create(:message, status: :pending) }

    context "with a delivered status" do
      let(:status) { "delivered" }

      it "updates the message status" do
        expect { service.call }.to change { message.reload.status }.from("pending").to("delivered")
      end
    end

    context "with a failed status" do
      let(:status) { "failed" }

      it "updates the message status" do
        expect { service.call }.to change { message.reload.status }.from("pending").to("failed")
      end
    end

    context "with an invalid status" do
      let(:status) { "invalid" }

      it "updates the message status" do
        expect { service.call }.to change { message.reload.status }.from("pending").to("incorrect")
      end
    end

    context "with an unknown status" do
      let(:status) { "unknown" }

      it "raises an error" do
        expect { service.call }.to raise_error(Messages::CallbackStatusError, "Invalid status: unknown")
        expect(message.reload.status).to eq("failed")
      end
    end
  end
end
