# frozen_string_literal: true
module CloudPayments
  module Namespaces
    class Kassa < Base
      InnNotProvided             = Class.new(StandardError)
      TypeNotProvided            = Class.new(StandardError)
      CustomerReceiptNotProvided = Class.new(StandardError)

      def self.resource_name
        'kkt'
      end

      def receipt(attributes)
        attributes.fetch(:inn)   { raise InnNotProvided.new('inn attribute is required') }
        attributes.fetch(:type)  { raise TypeNotProvided.new('type attribute is required') }
        attributes.fetch(:inn)   { raise CustomerReceiptNotProvided.new('customer_receipt is required') }

        request(:receipt, attributes)
      end
    end
  end
end
