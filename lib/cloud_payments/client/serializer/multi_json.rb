# frozen_string_literal: true
module CloudPayments
  class Client
    module Serializer
      class MultiJson < Base
        def load(json)
          return nil if json.empty?
          super(::MultiJson.load(json))
        end

        def dump(data)
          return '' if data.nil?
          ::MultiJson.dump(super(data))
        end
      end
    end
  end
end
