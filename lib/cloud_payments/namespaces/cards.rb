# frozen_string_literal: true
module CloudPayments
  module Namespaces
    class Cards < Base
      def charge(attributes)
        response = request(:charge, attributes)
        instantiate(response[:model])
      end

      def auth(attributes)
        response = request(:auth, attributes)
        instantiate(response[:model])
      end

      private

      def instantiate(model)
        if model[:pa_req]
          Secure3D.new(model)
        else
          Transaction.new(model)
        end
      end
    end
  end
end
