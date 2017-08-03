# frozen_string_literal: true
module CloudPayments
  class Subscription < Model
    include LikeSubscription

    property :id, required: true
    property :account_id, required: true
    property :description, required: true
    property :email, required: true
    property :amount, transform_with: DecimalTransform, required: true
    property :currency, required: true
    property :currency_code, required: true
    property :require_confirmation, transform_with: BooleanTransform, required: true
    property :started_at, from: :start_date_iso, with: DateTimeTransform, required: true
    property :interval, required: true
    property :interval_code, required: true
    property :period, transform_with: IntegralTransform, required: true
    property :max_periods
    property :status, required: true
    property :status_code, required: true
    property :successful_transactions, from: :successful_transactions_number, required: true
    property :failed_transactions, from: :failed_transactions_number, required: true
    property :last_transaction_at, from: :last_transaction_date_iso, with: DateTimeTransform
    property :next_transaction_at, from: :next_transaction_date_iso, with: DateTimeTransform
  end
end
