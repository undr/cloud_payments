require 'yaml'

module CloudPayments
  module RSpec
    module Helpers
      class StubApiRequest
        attr_reader :name

        def initialize(name)
          @name = name
        end

        def perform
          webmock_stub.to_return(
            status: response[:status] || 200,
            body: response[:body] || '',
            headers: response_headers
          ) if webmock_stub
        end

        def to_return(options)
          webmock_stub.to_return(return_options.merge(options)) if webmock_stub
        end

        def to_raise(*args)
          webmock_stub.to_raise(*args) if webmock_stub
        end

        def to_timeout
          webmock_stub.to_timeout if webmock_stub
        end

        private

        def return_options
          {
            status: response[:status] || 200,
            body: response[:body] || '',
            headers: response_headers
          }
        end

        def webmock_stub
          @webmock_stub ||= begin
            if fixture
              WebMock::StubRegistry.instance.register_request_stub(WebMock::RequestStub.new(:post, url)).
                with(body: request[:body] || '', headers: request_headers, basic_auth: ['user', 'pass'])
            end
          end
        end

        def url
          "http://localhost:9292#{request[:url]}"
        end

        def request_headers
          { 'Content-Type' => 'application/json' }.merge(request[:headers] || {})
        end

        def response_headers
          { 'Content-Type' => 'application/json' }.merge(response[:headers] || {})
        end

        def request
          fixture[:request] || {}
        end

        def response
          fixture[:response] || {}
        end

        def fixture
          @fixture ||= begin
            file = fixture_path.join("#{name}.yml").to_s
            YAML.load(File.read(file)) if File.exists?(file)
          end
        end

        def fixture_path
          Pathname.new(File.expand_path('../../fixtures/apis', __FILE__))
        end
      end

      def stub_api_request(name)
        StubApiRequest.new(name)
      end
    end
  end
end
