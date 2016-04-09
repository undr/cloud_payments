require 'spec_helper'

class TestNamespace < CloudPayments::Namespaces::Base
end

describe CloudPayments::Namespaces::Base do
  let(:headers){ { 'Content-Type' => 'application/json' } }
  let(:successful_body){ '{"Model":{},"Success":true}' }
  let(:failed_body){ '{"Success":false,"Message":"Error message"}' }
  let(:failed_transaction_body){ '{"Model":{"ReasonCode":5041,"CardHolderMessage":"Contact your bank"},"Success":false}' }
  let(:request_body){ '{"Amount":120,"CurrencyCode":"RUB"}' }
  let(:request_params){ { amount: 120, currency_code: 'RUB' } }

  subject{ TestNamespace.new(CloudPayments.client) }

  def stub_api(path, body = '')
    url = "http://user:pass@localhost:9292#{path}"
    stub_request(:post, url).with(body: body, headers: headers)
  end

  describe '#request' do
    context do
      before{ stub_api('/testnamespace', request_body).to_return(body: successful_body, headers: headers) }
      specify{ expect(subject.request(nil, request_params)) }
    end

    context 'with path' do
      before{ stub_api('/testnamespace/path', request_body).to_return(body: successful_body, headers: headers) }

      specify{ expect(subject.request(:path, request_params)) }
    end

    context 'with path and parent path' do
      subject{ TestNamespace.new(CloudPayments.client, 'parent') }

      before{ stub_api('/parent/testnamespace/path', request_body).to_return(body: successful_body, headers: headers) }

      specify{ expect(subject.request(:path, request_params)) }
    end

    context 'when status is greater than 300' do
      before{ stub_api('/testnamespace/path', request_body).to_return(status: 404, headers: headers) }

      specify{ expect{ subject.request(:path, request_params) }.to raise_error(CloudPayments::Client::Errors::NotFound) }
    end

    context 'when failed request' do
      before{ stub_api('/testnamespace/path', request_body).to_return(body: failed_body, headers: headers) }

      context 'config.raise_banking_errors = true' do
        before { CloudPayments.config.raise_banking_errors = true }
        specify{ expect{ subject.request(:path, request_params) }.to raise_error(CloudPayments::Client::GatewayError, 'Error message') }
      end

      context 'config.raise_banking_errors = false' do
        before { CloudPayments.config.raise_banking_errors = false }
        specify{ expect{ subject.request(:path, request_params) }.to raise_error(CloudPayments::Client::GatewayError, 'Error message') }
      end
    end

    context 'when failed transaction' do
      before{ stub_api('/testnamespace/path', request_body).to_return(body: failed_transaction_body, headers: headers) }

      context 'config.raise_banking_errors = true' do
        before { CloudPayments.config.raise_banking_errors = true }
        specify do
          begin
            subject.request(:path, request_params)
          rescue CloudPayments::Client::GatewayErrors::LostCard => err
            expect(err).to be_a CloudPayments::Client::ReasonedGatewayError
          end
        end
      end

      context 'config.raise_banking_errors = false' do
        before { CloudPayments.config.raise_banking_errors = false }
        specify{ expect{ subject.request(:path, request_params) }.not_to raise_error }
      end
    end
  end
end
