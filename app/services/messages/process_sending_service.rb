# TODO: check time of response
# Compare it with another service and adjust weights for services
# Save in redis
# Make services weights smarter: check in redis it weight present instead of using predefined weights
module Messages
  class ProcessSendingError < StandardError; end

  class ProcessSendingService
    SERVICES = [
      {service_id: 1, url: ENV.fetch("PROVIDER_SERVICE_URL1"), weight: 30}.freeze,
      {service_id: 2, url: ENV.fetch("PROVIDER_SERVICE_URL2"), weight: 70}.freeze,
    ].freeze

    def initialize(message_id)
      @message_id = message_id
      @total_weight = SERVICES.sum { |service| service[:weight] }
    end

    def call
      service = select_service
      result = Messages::SendService.new(service, @message_id).call

      unless result
        Rails.logger.warn "[PROVIDER_SERVICE FAIL] Delivering via #{service[:url]} failed"

        service = SERVICES.reject { _1[:service_id] == service[:service_id] }.first
        result = Messages::SendService.new(service, @message_id).call

        # We are processing asynchronously, so we can't raise error here
        # to see it in the bugtracker and handle manually
        raise Messages::ProcessSendingError, "All services are down. Message #{@message_id} can't be sent" unless result
      end

      true
    end

    def select_service
      weight = rand(1..@total_weight)

      return SERVICES.first if SERVICES.first[:weight] <= weight
      SERVICES.last
    end
  end
end
