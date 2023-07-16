require "rails_helper"

RSpec.describe Messages::ProcessSendingService do
  describe "#call" do
    subject { described_class.new(message_id) }

    let(:message_id) { "1q2w-1qw23e4r-1q2w3e4r" }

    before do
      srand(1) # seed for random
      expect(Messages::SendService)
        .to receive(:new)
        .with(Messages::ProcessSendingService::SERVICES.first, message_id)
        .and_return(double(call: result))
    end

    context "when service returns true" do
      let(:result) { true }

      it "returns true" do
        expect(subject.call).to eq(true)
      end
    end

    context "when service is down" do
      let(:result) { false }

      it "returns true" do
        expect(Messages::SendService)
          .to receive(:new)
          .with(Messages::ProcessSendingService::SERVICES.second, message_id)
          .and_return(double(call: true))
        expect(subject.call).to eq(true)
      end
    end

    context "when all services are down" do
      let(:result) { false }

      it "raises error" do
        expect(Messages::SendService)
          .to receive(:new)
          .with(Messages::ProcessSendingService::SERVICES.second, message_id)
          .and_return(double(call: false))

        expect {
          subject.call
        }.to raise_error(Messages::ProcessSendingError, "All services are down. Message #{message_id} can't be sent")
      end
    end
  end
end
