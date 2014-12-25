require 'cloud_payments/namespaces/base'
require 'cloud_payments/namespaces/cards'
require 'cloud_payments/namespaces/tokens'
require 'cloud_payments/namespaces/payments'
require 'cloud_payments/namespaces/subscriptions'

module CloudPayments
  module Namespaces
    def payments
      Payments.new(self)
    end

    def subscriptions
      Subscriptions.new(self)
    end

    def ping
      !!(perform_request('/test').body || {})[:success]
    rescue ::Faraday::Error::ConnectionFailed, ::Faraday::Error::TimeoutError, CloudPayments::Client::ServerError => e
      false
    end
  end
end
