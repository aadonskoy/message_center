module Messages
  class CallbackStatusError < StandardError; end

  class ProcessCallbackService
    def initialize(status:, message_id:)
      @status = status
      @message = Message.pending.find_by!(public_id: message_id)
    end

    def call
      case @status
      when "delivered" then @message.delivered!
      when "failed" then @message.failed!
      when "invalid" then @message.incorrect!
      else
        @message.failed!
        raise CallbackStatusError, "Invalid status: #{@status}"
      end
    end
  end
end
