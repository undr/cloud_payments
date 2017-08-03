# frozen_string_literal: true
module CloudPayments
  class Client
    class Response
      attr_reader :status, :origin_body, :headers

      def initialize(status, body, headers = {})
        @status, @origin_body, @headers = status, body, headers
        @origin_body = body.dup.force_encoding('UTF-8') if body.respond_to?(:force_encoding)
      end

      def body
        @body ||= headers && headers['content-type'] =~ /json/ ? serializer.load(origin_body) : origin_body
      end

      private

      def serializer
        CloudPayments.config.serializer
      end
    end
  end
end
