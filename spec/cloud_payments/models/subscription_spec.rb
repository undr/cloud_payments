# frozen_string_literal: true
require 'spec_helper'

describe CloudPayments::Subscription do
  subject{ CloudPayments::Subscription.new(attributes) }

  describe 'properties' do
    let(:attributes){ {
      id: 'sc_8cf8a9338fb8ebf7202b08d09c938',
      account_id: 'user@example.com',
      description: 'Monthly subscription',
      email: 'user@example.com',
      amount: 1.02,
      currency_code: 0,
      currency: 'RUB',
      require_confirmation: false,
      start_date_iso: '2014-08-09T11:49:41',
      interval_code: 1,
      interval: 'Month',
      period: 1,
      max_periods: 12,
      status_code: 0,
      status: 'Active',
      successful_transactions_number: 0,
      failed_transactions_number: 0,
      last_transaction_date_iso: '2014-08-09T11:49:41',
      next_transaction_date_iso: '2014-08-09T11:49:41'
    } }

    specify{ expect(subject.id).to eq('sc_8cf8a9338fb8ebf7202b08d09c938') }
    specify{ expect(subject.account_id).to eq('user@example.com') }
    specify{ expect(subject.description).to eq('Monthly subscription') }
    specify{ expect(subject.email).to eq('user@example.com') }
    specify{ expect(subject.amount).to eq(1.02) }
    specify{ expect(subject.currency_code).to eq(0) }
    specify{ expect(subject.currency).to eq('RUB') }
    specify{ expect(subject.require_confirmation).to be_falsy }
    specify{ expect(subject.started_at).to eq(DateTime.parse('2014-08-09T11:49:41')) }
    specify{ expect(subject.interval_code).to eq(1) }
    specify{ expect(subject.interval).to eq('Month') }
    specify{ expect(subject.period).to eq(1) }
    specify{ expect(subject.max_periods).to eq(12) }
    specify{ expect(subject.status_code).to eq(0) }
    specify{ expect(subject.status).to eq('Active') }
    specify{ expect(subject.successful_transactions).to eq(0) }
    specify{ expect(subject.failed_transactions).to eq(0) }
    specify{ expect(subject.last_transaction_at).to eq(DateTime.parse('2014-08-09T11:49:41')) }
    specify{ expect(subject.next_transaction_at).to eq(DateTime.parse('2014-08-09T11:49:41')) }

    context 'without any attributes' do
      let(:attributes){ {} }
      specify{ expect{ subject }.to raise_error(/\'id\' is required/) }
    end

    it_behaves_like :raise_without_attribute, :id
    it_behaves_like :raise_without_attribute, :account_id
    it_behaves_like :raise_without_attribute, :description
    it_behaves_like :raise_without_attribute, :email
    it_behaves_like :raise_without_attribute, :amount
    it_behaves_like :raise_without_attribute, :currency_code
    it_behaves_like :raise_without_attribute, :currency
    it_behaves_like :raise_without_attribute, :require_confirmation
    it_behaves_like :raise_without_attribute, :start_date_iso, :started_at
    it_behaves_like :raise_without_attribute, :interval_code
    it_behaves_like :raise_without_attribute, :interval
    it_behaves_like :raise_without_attribute, :period
    it_behaves_like :raise_without_attribute, :status_code
    it_behaves_like :raise_without_attribute, :status
    it_behaves_like :raise_without_attribute, :successful_transactions_number, :successful_transactions
    it_behaves_like :raise_without_attribute, :failed_transactions_number, :failed_transactions

    it_behaves_like :not_raise_without_attribute, :max_periods
    it_behaves_like :not_raise_without_attribute, :last_transaction_date_iso, :last_transaction_at
    it_behaves_like :not_raise_without_attribute, :next_transaction_date_iso, :next_transaction_at
  end

  describe 'status' do
    let(:attributes){ {
      id: 'sc_8cf8a9338fb8ebf7202b08d09c938',
      account_id: 'user@example.com',
      description: 'Monthly subscription',
      email: 'user@example.com',
      amount: 1.02,
      currency_code: 0,
      currency: 'RUB',
      require_confirmation: false,
      start_date_iso: '2014-08-09T11:49:41',
      interval_code: 1,
      interval: 'Month',
      period: 1,
      status_code: 0,
      status: status,
      successful_transactions_number: 0,
      failed_transactions_number: 0
    } }

    context 'when status == Active' do
      let(:status){ 'Active' }
      specify{ expect(subject).to be_active }
      specify{ expect(subject).not_to be_past_due }
      specify{ expect(subject).not_to be_cancelled }
      specify{ expect(subject).not_to be_rejected }
      specify{ expect(subject).not_to be_expired }
    end

    context 'when status == PastDue' do
      let(:status){ 'PastDue' }
      specify{ expect(subject).not_to be_active }
      specify{ expect(subject).to be_past_due }
      specify{ expect(subject).not_to be_cancelled }
      specify{ expect(subject).not_to be_rejected }
      specify{ expect(subject).not_to be_expired }
    end

    context 'when status == Cancelled' do
      let(:status){ 'Cancelled' }
      specify{ expect(subject).not_to be_active }
      specify{ expect(subject).not_to be_past_due }
      specify{ expect(subject).to be_cancelled }
      specify{ expect(subject).not_to be_rejected }
      specify{ expect(subject).not_to be_expired }
    end

    context 'when status == Rejected' do
      let(:status){ 'Rejected' }
      specify{ expect(subject).not_to be_active }
      specify{ expect(subject).not_to be_past_due }
      specify{ expect(subject).not_to be_cancelled }
      specify{ expect(subject).to be_rejected }
      specify{ expect(subject).not_to be_expired }
    end

    context 'when status == Expired' do
      let(:status){ 'Expired' }
      specify{ expect(subject).not_to be_active }
      specify{ expect(subject).not_to be_past_due }
      specify{ expect(subject).not_to be_cancelled }
      specify{ expect(subject).not_to be_rejected }
      specify{ expect(subject).to be_expired }
    end
  end
end
