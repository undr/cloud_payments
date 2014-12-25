module CloudPayments
  module Namespaces
    class Tokens < Base
      def charge(attributes)
        response = request(:charge, attributes)
        Transaction.new(response[:model])
      end

      def auth(attributes)
        response = request(:auth, attributes)
        Transaction.new(response[:model])
      end
    end
  end
end
