# frozen_string_literal: true
module CloudPayments
  module Namespaces
    class Orders < Base
      def create(attributes)
        response = request(:create, attributes)
        Order.new(response[:model])
      end

      def cancel(order_id)
        request(:cancel, id: order_id)[:success]
      end
    end
  end
end
