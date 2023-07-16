module Api
  class MessagesController < Base
    def create
      message = Message.new(message_params)
      if message.save
        Messages::SendJob.perform_later(message.reload.public_id)

        render json: message, only: [:public_id, :status, :text, :phone_number]
      else
        render json: { errors: message.errors }, status: :unprocessable_entity
      end
    end

    private

    def message_params
      params.require(:message).permit(:text, :phone_number)
    end
  end
end
