# frozen_string_literal: true
module CloudPayments
  class Client
    module Serializer
      class Base
        attr_reader :config

        def initialize(config)
          @config = config
        end

        def load(json)
          convert_keys_from_api(json)
        end

        def dump(hash)
          convert_keys_to_api(hash)
        end

        protected

        def convert_keys_from_api(attributes)
          attributes.each_with_object({}) do |(key, value), result|
            value = case value
            when Hash
              convert_keys_from_api(value)
            when Array
              value.map { |item| convert_keys_from_api(item) }
            else
              value
            end

            key = key.to_s.gsub(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2')
            key.gsub!(/([a-z\d])([A-Z])/, '\1_\2')
            key.tr!('-', '_')
            key.downcase!
            result[key.to_sym] = value
          end
        end

        def convert_keys_to_api(attributes)
          attributes.each_with_object({}) do |(key, value), result|
            value = convert_keys_to_api(value) if value.is_a?(Hash)

            key = key.to_s.gsub(/^[a-z\d]*/){ $&.capitalize }
            key.gsub!(/(?:_|(\/))([a-z\d]*)/i){ "#{$1}#{$2.capitalize}" }
            key.gsub!('/', '::')
            result[key] = value
          end
        end
      end
    end
  end
end
