module CloudPayments
  module Namespaces
    class Base
      attr_reader :client, :parent_path

      class << self
        def resource_name
          self.name.split('::').last.downcase
        end
      end

      def initialize(client, parent_path = nil)
        @client = client
        @parent_path = parent_path
      end

      def request(path, params = {})
        response = client.perform_request(resource_path(path), params)
        raise_gateway_error_if_needed(response.body) unless response.body[:success]
        response.body
      end

      protected

      def api_exceptions
        [::Faraday::Error::ConnectionFailed, ::Faraday::Error::TimeoutError, Client::ServerError, Client::GatewayError]
      end

      def resource_path(path = nil)
        [parent_path, self.class.resource_name, path].flatten.compact.join(?/).squeeze(?/)
      end

      def raise_gateway_error_if_needed(body)
        raise Client::GatewayError.new(body[:message], body) if !body[:message].nil? && !body[:message].empty?
      end
    end
  end
end
