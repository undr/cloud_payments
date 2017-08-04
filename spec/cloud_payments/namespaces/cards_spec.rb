# frozen_string_literal: true
require 'spec_helper'

describe CloudPayments::Namespaces::Cards do
  subject{ CloudPayments::Namespaces::Cards.new(CloudPayments.client, '/payments') }

  let(:attributes){ {
    amount: 10,
    currency: 'RUB',
    invoice_id: '1234567',
    description: 'Payment for goods on example.com',
    account_id: 'user_x',
    name: 'CARDHOLDER NAME',
    card_cryptogram_packet: '01492500008719030128SM'
  } }

  context do
    context 'config.raise_banking_errors = false' do
      before { CloudPayments.config.raise_banking_errors = false }

      describe '#charge' do
        before{ stub_api_request('cards/charge/successful').perform }
        specify{ expect(subject.charge(attributes)).to be_instance_of(CloudPayments::Transaction) }
        specify{ expect(subject.charge(attributes)).not_to be_required_secure3d }
        specify{ expect(subject.charge(attributes)).to be_completed }
        specify{ expect(subject.charge(attributes).id).to eq(12345) }
      end

      context do
        before{ stub_api_request('cards/charge/secure3d').perform }
        specify{ expect(subject.charge(attributes)).to be_instance_of(CloudPayments::Secure3D) }
        specify{ expect(subject.charge(attributes)).to be_required_secure3d }
        specify{ expect(subject.charge(attributes).id).to eq(12345) }
        specify{ expect(subject.charge(attributes).transaction_id).to eq(12345) }
        specify{ expect(subject.charge(attributes).pa_req).to eq('eJxVUdtugkAQ') }
        specify{ expect(subject.charge(attributes).acs_url).to eq('https://test.paymentgate.ru/acs/auth/start.do') }
      end

      context do
        before{ stub_api_request('cards/charge/failed').perform }
        specify{ expect(subject.charge(attributes)).to be_instance_of(CloudPayments::Transaction) }
        specify{ expect(subject.charge(attributes)).not_to be_required_secure3d }
        specify{ expect(subject.charge(attributes)).to be_declined }
        specify{ expect(subject.charge(attributes).id).to eq(12345) }
        specify{ expect(subject.charge(attributes).reason).to eq('InsufficientFunds') }
      end
    end

    context 'config.raise_banking_errors = true' do
      before { CloudPayments.config.raise_banking_errors = true }

      context do
        before{ stub_api_request('cards/charge/successful').perform }
        specify{ expect{ subject.charge(attributes) }.not_to raise_error }
      end

      context do
        before{ stub_api_request('cards/charge/secure3d').perform }
        specify{ expect{ subject.charge(attributes) }.not_to raise_error }
      end

      context do
        before{ stub_api_request('cards/charge/failed').perform }
        specify{ expect{ subject.charge(attributes) }.to raise_error(CloudPayments::Client::GatewayErrors::InsufficientFunds) }
      end
    end
  end

  describe '#auth' do
    context 'config.raise_banking_errors = false' do
      before { CloudPayments.config.raise_banking_errors = false }

      context do
        before{ stub_api_request('cards/auth/successful').perform }
        specify{ expect(subject.auth(attributes)).to be_instance_of(CloudPayments::Transaction) }
        specify{ expect(subject.auth(attributes)).not_to be_required_secure3d }
        specify{ expect(subject.auth(attributes)).to be_authorized }
        specify{ expect(subject.auth(attributes).id).to eq(12345) }
      end

      context do
        before{ stub_api_request('cards/auth/secure3d').perform }
        specify{ expect(subject.auth(attributes)).to be_instance_of(CloudPayments::Secure3D) }
        specify{ expect(subject.auth(attributes)).to be_required_secure3d }
        specify{ expect(subject.auth(attributes).id).to eq(12345) }
        specify{ expect(subject.auth(attributes).transaction_id).to eq(12345) }
        specify{ expect(subject.auth(attributes).pa_req).to eq('eJxVUdtugkAQ') }
        specify{ expect(subject.auth(attributes).acs_url).to eq('https://test.paymentgate.ru/acs/auth/start.do') }
      end

      context do
        before{ stub_api_request('cards/auth/failed').perform }
        specify{ expect(subject.auth(attributes)).to be_instance_of(CloudPayments::Transaction) }
        specify{ expect(subject.auth(attributes)).not_to be_required_secure3d }
        specify{ expect(subject.auth(attributes)).to be_declined }
        specify{ expect(subject.auth(attributes).id).to eq(12345) }
        specify{ expect(subject.auth(attributes).reason).to eq('InsufficientFunds') }
      end
    end

    context 'config.raise_banking_errors = true' do
      before { CloudPayments.config.raise_banking_errors = true }

      context do
        before{ stub_api_request('cards/auth/successful').perform }
        specify{ expect{ subject.auth(attributes) }.not_to raise_error }
      end

      context do
        before{ stub_api_request('cards/auth/secure3d').perform }
        specify{ expect{ subject.auth(attributes) }.not_to raise_error }
      end

      context do
        before{ stub_api_request('cards/auth/failed').perform }
        specify{ expect{ subject.auth(attributes) }.to raise_error(CloudPayments::Client::GatewayErrors::InsufficientFunds) }
      end
    end
  end
end
