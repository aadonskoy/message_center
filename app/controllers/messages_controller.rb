class MessagesController < ApplicationController
  def index
    @messages =
      if params[:phone_number].present?
        Message.where("phone_number LIKE ?", "%#{params[:phone_number]}%")
      else
        Message.order(created_at: :desc)
      end
        .order(created_at: :desc)
        .page(params[:page])
  end
end
