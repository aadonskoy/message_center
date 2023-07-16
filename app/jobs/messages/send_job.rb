module Messages
  class SendJob < ApplicationJob
    queue_as :default

    def perform(message_id)
      Messages::ProcessSendingService.new(message_id).call
    end
  end
end
