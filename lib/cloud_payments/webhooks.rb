require 'openssl'
require 'base64'

module CloudPayments
  class Webhooks
    class HMACError < StandardError; end

    attr_reader :config

    def initialize
      @config = CloudPayments.config
      @digest = OpenSSL::Digest.new('sha256')
    end

    def data_valid?(data, hmac)
      Base64.decode64(hmac) == OpenSSL::HMAC.digest(@digest, config.secret_key, data)
    end

    def validate_data!(data, hmac)
      raise HMACError unless data_valid?(data, hmac)
      true
    end
  end
end
