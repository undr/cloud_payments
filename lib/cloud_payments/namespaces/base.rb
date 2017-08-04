# frozen_string_literal: true
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
        raise_gateway_error(response.body) unless response.body[:success]
        response.body
      end

      protected

      def api_exceptions
        [::Faraday::Error::ConnectionFailed, ::Faraday::Error::TimeoutError, Client::ServerError, Client::GatewayError]
      end

      def resource_path(path = nil)
        [parent_path, self.class.resource_name, path].flatten.compact.join(?/).squeeze(?/)
      end

      def raise_gateway_error(body)
        raise_reasoned_gateway_error(body) || raise_raw_gateway_error(body)
      end

      def raise_reasoned_gateway_error(body)
        fail Client::GATEWAY_ERRORS[body[:model][:reason_code]].new(body) if reason_present?(body)
      end

      def raise_raw_gateway_error(body)
        fail Client::GatewayError.new(body[:message], body) if !body[:message].nil? && !body[:message].empty?
      end

      def reason_present?(body)
        !body[:model].nil? && !body[:model].empty? && !body[:model][:reason_code].nil? && CloudPayments.config.raise_banking_errors
      end
    end
  end
end
