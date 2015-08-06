require 'spec_helper'

describe CloudPayments::Namespaces::Payments do
  subject{ CloudPayments::Namespaces::Payments.new(CloudPayments.client) }

  describe '#cards' do
    specify{ expect(subject.cards).to be_instance_of(CloudPayments::Namespaces::Cards) }
    specify{ expect(subject.cards.parent_path).to eq('payments') }
  end

  describe '#tokens' do
    specify{ expect(subject.tokens).to be_instance_of(CloudPayments::Namespaces::Tokens) }
    specify{ expect(subject.tokens.parent_path).to eq('payments') }
  end

  describe '#confirm' do
    context do
      before{ stub_api_request('payments/confirm/successful').perform }
      specify{ expect(subject.confirm(12345, 120)).to be_truthy }
    end

    context do
      before{ stub_api_request('payments/confirm/failed').perform }
      specify{ expect(subject.confirm(12345, 120)).to be_falsy }
    end

    context do
      before{ stub_api_request('payments/confirm/failed_with_message').perform }
      specify{ expect{ subject.confirm(12345, 120) }.to raise_error(CloudPayments::Client::GatewayError, 'Error message') }
    end
  end

  describe '#void' do
    context do
      before{ stub_api_request('payments/void/successful').perform }
      specify{ expect(subject.void(12345)).to be_truthy }
    end

    context do
      before{ stub_api_request('payments/void/failed').perform }
      specify{ expect(subject.void(12345)).to be_falsy }
    end

    context do
      before{ stub_api_request('payments/void/failed_with_message').perform }
      specify{ expect{ subject.void(12345) }.to raise_error(CloudPayments::Client::GatewayError, 'Error message') }
    end
  end

  describe '#refund' do
    context do
      before{ stub_api_request('payments/refund/successful').perform }
      specify{ expect(subject.refund(12345, 120)).to be_truthy }
    end

    context do
      before{ stub_api_request('payments/refund/failed').perform }
      specify{ expect(subject.refund(12345, 120)).to be_falsy }
    end

    context do
      before{ stub_api_request('payments/refund/failed_with_message').perform }
      specify{ expect{ subject.refund(12345, 120) }.to raise_error(CloudPayments::Client::GatewayError, 'Error message') }
    end
  end

  describe '#post3ds' do
    context 'config.raise_banking_errors = false' do
      before { CloudPayments.config.raise_banking_errors = false }

      context do
        before{ stub_api_request('payments/post3ds/successful').perform }
        specify{ expect(subject.post3ds(12345, 'eJxVUdtugkAQ')).to be_instance_of(CloudPayments::Transaction) }
      end

      context do
        before{ stub_api_request('payments/post3ds/failed').perform }
        specify{ expect{ subject.post3ds(12345, 'eJxVUdtugkAQ') }.not_to raise_error }
      end
    end

    context 'config.raise_banking_errors = true' do
      before { CloudPayments.config.raise_banking_errors = true }

      context do
        before{ stub_api_request('payments/post3ds/successful').perform }
        specify{ expect{ subject.post3ds(12345, 'eJxVUdtugkAQ') }.not_to raise_error }
      end

      context do
        before{ stub_api_request('payments/post3ds/failed').perform }
        specify{ expect{ subject.post3ds(12345, 'eJxVUdtugkAQ') }.to raise_error(CloudPayments::Client::GatewayErrors::InsufficientFunds)  }
      end
    end
  end
end
