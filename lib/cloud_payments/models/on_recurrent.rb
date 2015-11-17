module CloudPayments
  class OnRecurrent < Model
    property :id, required: true
    property :account_id, required: true
    property :description, required: true
    property :email, required: true
    property :amount, transform_with: DecimalTransform, required: true
    property :currency, required: true
    property :require_confirmation, transform_with: BooleanTransform, required: true
    property :started_at, from: :start_date, with: DateTimeTransform, required: true
    property :interval, required: true
    property :period, transform_with: IntegralTransform, required: true
    property :status, required: true
    property :successful_transactions, from: :successful_transactions_number, with: IntegralTransform, required: true
    property :failed_transactions, from: :failed_transactions_number, with: IntegralTransform, required: true
    property :last_transaction_at, from: :last_transaction_date, with: DateTimeTransform
    property :next_transaction_at, from: :next_transaction_date, with: DateTimeTransform

    include LikeSubscription
  end
end
