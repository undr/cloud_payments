module CloudPayments
  module Namespaces
    class Orders < Base
      def create(attributes)
        response = request(:create, attributes)
        Order.new(response[:model])
      end
    end
  end
end
