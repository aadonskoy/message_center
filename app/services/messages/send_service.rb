module Messages
  class SendService
    CALLBACK_URL = "#{ENV.fetch("CALLBACK_URL")}/api/webhooks/messages".freeze

    def initialize(service, message_id)
      @service = service
      @message = Message.created.find_by!(public_id: message_id)
    end

    def call
      response = Faraday.post(service_url, message_params) do |req|
        req.headers["Content-Type"] = "application/json"
      end

      Rails.logger.info "==== Message #{@message} was sent to #{@service[:url]} with status #{response&.status}"
      if response.status == 200
        @message.pending!
        true
      else
        false
      end
    end

    private

    def message_params
      {
        message: @message.text,
        to_number: @message.phone_number,
        callback_url: targeted_callback_url
      }.to_json
    end

    def targeted_callback_url = "#{CALLBACK_URL}?message_orig_id=#{message_orig_id}&service_id=#{service_id}&timestamp=#{timestamp}"
    def timestamp = Time.current.to_i

    def service_id = @service[:service_id]
    def service_url = @service[:url]
    def message_orig_id = @message.public_id
  end
end
