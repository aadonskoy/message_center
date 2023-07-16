require "rails_helper"

RSpec.describe Messages::SendService do
  describe "#call" do
    subject { described_class.new(provider_service, message_id) }

    let(:provider_service) { { service_id: 1, url: "http://example.com" } }
    let(:message_id) { message.reload.public_id }
    let!(:message) { create(:message) }

    context "when message is found" do
      before do
        stub_request(:post, provider_service[:url]).to_return(status: status)
      end

      context "when service returns 200" do
        let(:status) { 200 }

        it "updates message status to pending" do
          expect { subject.call }.to change { message.reload.status }.to("pending")
        end

        it "returns true" do
          expect(subject.call).to eq(true)
        end
      end

      context "when service returns 500" do
        let(:status) { 500 }

        it "does not update message status" do
          expect { subject.call }.not_to change { message.reload.status }
        end

        it "returns false" do
          expect(subject.call).to eq(false)
        end
      end
    end

    context "when message is not found" do
      let(:message_id) { "invalid" }

      it "raises ActiveRecord::RecordNotFound" do
        expect { subject.call }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
