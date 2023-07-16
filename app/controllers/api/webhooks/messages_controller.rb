module Api
  module Webhooks
    class MessagesController < Base
      def create
        Messages::ProcessCallbackService.new(
          status: params[:status],
          message_id: params[:message_orig_id]
        ).call

        head :accepted
      end
    end
  end
end
