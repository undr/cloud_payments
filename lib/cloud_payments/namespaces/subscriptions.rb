module CloudPayments
  module Namespaces
    class Subscriptions < Base
      def find(id)
        response = request(:get, id: id)
        Subscription.new(response[:model])
      end

      def find_all(account_id)
        response = request(:find, account_id: account_id)
        Array(response[:model]).map { |item| Subscription.new(item) }
      end

      def create(attributes)
        response = request(:create, attributes)
        Subscription.new(response[:model])
      end

      def update(id, attributes)
        response = request(:update, attributes.merge(id: id))
        Subscription.new(response[:model])
      end

      def cancel(id)
        request(:cancel, id: id)[:success]
      end
    end
  end
end
