# frozen_string_literal: true
require 'spec_helper'

describe CloudPayments::Namespaces do
  subject{ CloudPayments::Client.new }

  describe '#payments' do
    specify{ expect(subject.payments).to be_instance_of(CloudPayments::Namespaces::Payments) }
  end

  describe '#subscriptions' do
    specify{ expect(subject.subscriptions).to be_instance_of(CloudPayments::Namespaces::Subscriptions) }
  end

  describe '#ping' do
    context 'when successful response' do
      before{ stub_api_request('ping/successful').perform }
      specify{ expect(subject.ping).to be_truthy }
    end

    context 'when failed response' do
      before{ stub_api_request('ping/failed').perform }
      specify{ expect(subject.ping).to be_falsy }
    end

    context 'when empty response' do
      before{ stub_api_request('ping/failed').to_return(body: '') }
      specify{ expect(subject.ping).to be_falsy }
    end

    context 'when error response' do
      before{ stub_api_request('ping/failed').to_return(status: 404) }
      specify{ expect(subject.ping).to be_falsy }
    end

    context 'when exception occurs while request' do
      before{ stub_api_request('ping/failed').to_raise(::Faraday::Error::ConnectionFailed) }
      specify{ expect(subject.ping).to be_falsy }
    end

    context 'when timeout occurs while request' do
      before{ stub_api_request('ping/failed').to_timeout }
      specify{ expect(subject.ping).to be_falsy }
    end
  end
end
