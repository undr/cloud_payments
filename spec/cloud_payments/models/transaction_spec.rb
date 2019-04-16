# frozen_string_literal: true
require 'spec_helper'

describe CloudPayments::Transaction do
  subject{ CloudPayments::Transaction.new(attributes) }

  describe 'properties' do
    let(:attributes){ {
      transaction_id: 504,
      amount: 10.0,
      currency: 'RUB',
      currency_code: 0,
      invoice_id: '1234567',
      account_id: 'user_x',
      subscription_id: 'sc_8cf8a9338fb8ebf7202b08d09c938',
      email: 'user@example.com',
      description: 'Buying goods in example.com',
      json_data: { key: 'value' },
      date_time: '2014-08-09T11:49:41',
      created_date_iso: '2014-08-09T11:49:41',
      auth_date_iso: '2014-08-09T11:49:41',
      confirm_date_iso: '2014-08-09T11:49:41',
      auth_code: '123456',
      test_mode: true,
      ip_address: '195.91.194.13',
      ip_country: 'RU',
      ip_city: 'Ufa',
      ip_region: 'Republic of Bashkortostan',
      ip_district: 'Volga Federal District',
      ip_latitude: 54.7355,
      ip_longitude: 55.991982,
      card_first_six: '411111',
      card_last_four: '1111',
      card_type: 'Visa',
      card_type_code: 0,
      card_exp_date: '10/17',
      issuer: 'Sberbank of Russia',
      issuer_bank_country: 'RU',
      status: 'Completed',
      status_code: 3,
      reason: 'Approved',
      reason_code: 0,
      refunded: false,
      card_holder_message: 'Payment successful',
      name: 'CARDHOLDER NAME',
      token: 'a4e67841-abb0-42de-a364-d1d8f9f4b3c0'
    } }

    specify{ expect(subject.id).to eq(504) }
    specify{ expect(subject.amount).to eq(10.0) }
    specify{ expect(subject.currency).to eq('RUB') }
    specify{ expect(subject.currency_code).to eq(0) }
    specify{ expect(subject.invoice_id).to eq('1234567') }
    specify{ expect(subject.account_id).to eq('user_x') }
    specify{ expect(subject.subscription_id).to eq('sc_8cf8a9338fb8ebf7202b08d09c938') }
    specify{ expect(subject.email).to eq('user@example.com') }
    specify{ expect(subject.description).to eq('Buying goods in example.com') }
    specify{ expect(subject.metadata).to eq(key: 'value') }
    specify{ expect(subject.date_time).to eq(DateTime.parse('2014-08-09T11:49:41')) }
    specify{ expect(subject.created_at).to eq(DateTime.parse('2014-08-09T11:49:41')) }
    specify{ expect(subject.authorized_at).to eq(DateTime.parse('2014-08-09T11:49:41')) }
    specify{ expect(subject.confirmed_at).to eq(DateTime.parse('2014-08-09T11:49:41')) }
    specify{ expect(subject.auth_code).to eq('123456') }
    specify{ expect(subject.test_mode).to be_truthy }
    specify{ expect(subject.ip_address).to eq('195.91.194.13') }
    specify{ expect(subject.ip_country).to eq('RU') }
    specify{ expect(subject.ip_city).to eq('Ufa') }
    specify{ expect(subject.ip_region).to eq('Republic of Bashkortostan') }
    specify{ expect(subject.ip_district).to eq('Volga Federal District') }
    specify{ expect(subject.ip_lat).to eq(54.7355) }
    specify{ expect(subject.ip_lng).to eq(55.991982) }
    specify{ expect(subject.card_first_six).to eq('411111') }
    specify{ expect(subject.card_last_four).to eq('1111') }
    specify{ expect(subject.card_type).to eq('Visa') }
    specify{ expect(subject.card_type_code).to eq(0) }
    specify{ expect(subject.card_exp_date).to eq('10/17') }
    specify{ expect(subject.issuer).to eq('Sberbank of Russia') }
    specify{ expect(subject.issuer_bank_country).to eq('RU') }
    specify{ expect(subject.reason).to eq('Approved') }
    specify{ expect(subject.reason_code).to eq(0) }
    specify{ expect(subject.card_holder_message).to eq('Payment successful') }
    specify{ expect(subject.name).to eq('CARDHOLDER NAME') }
    specify{ expect(subject.token).to eq('a4e67841-abb0-42de-a364-d1d8f9f4b3c0') }
    specify{ expect(subject.refunded).to eq(false) }

    context 'without any attributes' do
      let(:attributes){ {} }
      specify{ expect{ subject }.to raise_error(/\'id\' is required/) }
    end

    it_behaves_like :raise_without_attribute, :transaction_id, :id
    it_behaves_like :raise_without_attribute, :amount
    it_behaves_like :raise_without_attribute, :currency
    it_behaves_like :raise_without_attribute, :test_mode
    it_behaves_like :raise_without_attribute, :card_first_six
    it_behaves_like :raise_without_attribute, :card_last_four
    it_behaves_like :raise_without_attribute, :card_type

    it_behaves_like :not_raise_without_attribute, :currency_code
    it_behaves_like :not_raise_without_attribute, :invoice_id
    it_behaves_like :not_raise_without_attribute, :account_id
    it_behaves_like :not_raise_without_attribute, :email
    it_behaves_like :not_raise_without_attribute, :description
    it_behaves_like :not_raise_without_attribute, :date_time
    it_behaves_like :not_raise_without_attribute, :created_date_iso, :created_at
    it_behaves_like :not_raise_without_attribute, :auth_date_iso, :authorized_at
    it_behaves_like :not_raise_without_attribute, :confirm_date_iso, :confirmed_at
    it_behaves_like :not_raise_without_attribute, :auth_code
    it_behaves_like :not_raise_without_attribute, :ip_address
    it_behaves_like :not_raise_without_attribute, :ip_country
    it_behaves_like :not_raise_without_attribute, :ip_city
    it_behaves_like :not_raise_without_attribute, :ip_region
    it_behaves_like :not_raise_without_attribute, :ip_district
    it_behaves_like :not_raise_without_attribute, :ip_latitude, :ip_lat
    it_behaves_like :not_raise_without_attribute, :ip_longitude, :ip_lng
    it_behaves_like :not_raise_without_attribute, :card_type_code
    it_behaves_like :not_raise_without_attribute, :card_exp_date
    it_behaves_like :not_raise_without_attribute, :issuer
    it_behaves_like :not_raise_without_attribute, :issuer_bank_country
    it_behaves_like :not_raise_without_attribute, :reason
    it_behaves_like :not_raise_without_attribute, :reason_code
    it_behaves_like :not_raise_without_attribute, :refunded
    it_behaves_like :not_raise_without_attribute, :card_holder_message
    it_behaves_like :not_raise_without_attribute, :name
    it_behaves_like :not_raise_without_attribute, :token

    context 'without `metadata` attribute' do
      subject do
        attrs = attributes.dup
        attrs.delete(:json_data)
        described_class.new(attrs)
      end

      specify{ expect{ subject }.not_to raise_error }
      specify{ expect(subject.metadata).to eq({}) }
    end
  end

  describe 'status' do
    let(:attributes){ {
      transaction_id: 504,
      amount: 10.0,
      currency: 'RUB',
      test_mode: true,
      card_first_six: '411111',
      card_last_four: '1111',
      card_type: 'Visa',
      card_exp_date: '10/17',
      status: status
    } }

    context 'when status == AwaitingAuthentication' do
      let(:status){ 'AwaitingAuthentication' }
      specify{ expect(subject).to be_awaiting_authentication }
      specify{ expect(subject).not_to be_completed }
      specify{ expect(subject).not_to be_authorized }
      specify{ expect(subject).not_to be_cancelled }
      specify{ expect(subject).not_to be_declined }
    end

    context 'when status == Completed' do
      let(:status){ 'Completed' }
      specify{ expect(subject).not_to be_awaiting_authentication }
      specify{ expect(subject).to be_completed }
      specify{ expect(subject).not_to be_authorized }
      specify{ expect(subject).not_to be_cancelled }
      specify{ expect(subject).not_to be_declined }
    end

    context 'when status == Authorized' do
      let(:status){ 'Authorized' }
      specify{ expect(subject).not_to be_awaiting_authentication }
      specify{ expect(subject).not_to be_completed }
      specify{ expect(subject).to be_authorized }
      specify{ expect(subject).not_to be_cancelled }
      specify{ expect(subject).not_to be_declined }
    end

    context 'when status == Cancelled' do
      let(:status){ 'Cancelled' }
      specify{ expect(subject).not_to be_awaiting_authentication }
      specify{ expect(subject).not_to be_completed }
      specify{ expect(subject).not_to be_authorized }
      specify{ expect(subject).to be_cancelled }
      specify{ expect(subject).not_to be_declined }
    end

    context 'when status == Declined' do
      let(:status){ 'Declined' }
      specify{ expect(subject).not_to be_awaiting_authentication }
      specify{ expect(subject).not_to be_completed }
      specify{ expect(subject).not_to be_authorized }
      specify{ expect(subject).not_to be_cancelled }
      specify{ expect(subject).to be_declined }
    end
  end

  context do
    let(:attributes){ {} }
    let(:default_attributes){ {
      transaction_id: 504,
      amount: 10.0,
      currency: 'RUB',
      test_mode: true,
      card_first_six: '411111',
      card_last_four: '1111',
      card_type: 'Visa',
      card_exp_date: '10/17',
      status: 'Completed'
    } }

    subject{ CloudPayments::Transaction.new(default_attributes.merge(attributes)) }

    describe '#subscription' do
      before{ stub_api_request('subscriptions/get/successful').perform }

      context 'with subscription_id' do
        let(:attributes){ { subscription_id: 'sc_8cf8a9338fb' } }

        specify{ expect(subject.subscription).to be_instance_of(CloudPayments::Subscription) }

        context do
          let(:sub){ subject.subscription }

          specify{ expect(sub.id).to eq('sc_8cf8a9338fb') }
          specify{ expect(sub.account_id).to eq('user@example.com') }
          specify{ expect(sub.description).to eq('Monthly subscription') }
          specify{ expect(sub.started_at).to eq(DateTime.parse('2014-08-09T11:49:41')) }
          specify{ expect(sub).to be_active }
        end
      end

      context 'without subscription_id' do
        specify{ expect(subject.subscription).to be_nil }
      end
    end

    describe '#card_number' do
      specify{ expect(subject.card_number).to eq('4111 11XX XXXX 1111') }
    end

    describe '#ip_location' do
      specify{ expect(subject.ip_location).to be_nil }

      context do
        let(:attributes){ { ip_latitude: 12.34, ip_longitude: 56.78 } }
        specify{ expect(subject.ip_location).to eq([12.34, 56.78]) }
      end

      context do
        let(:attributes){ { ip_latitude: 12.34 } }
        specify{ expect(subject.ip_location).to be_nil }
      end

      context do
        let(:attributes){ { ip_longitude: 12.34 } }
        specify{ expect(subject.ip_location).to be_nil }
      end
    end

    describe '#refunded?' do
      context do
        let(:attributes) { { refunded: false } }
        specify { expect(subject.refunded?).to be_falsey }
      end

      context do
        let(:attributes) { { refunded: true } }
        specify { expect(subject.refunded?).to be_truthy }
      end

      context do
        let(:attributes) { { refunded: nil } }
        specify { expect(subject.refunded?).to be_falsey }
      end
    end
  end
end
