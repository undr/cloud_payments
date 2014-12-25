module CloudPayments
  class Subscription < Model
    ACTIVE = 'Active'
    PAST_DUE = 'PastDue'
    CANCELLED = 'Cancelled'
    REJECTED = 'Rejected'
    EXPIRED = 'Expired'

    property :id, required: true
    property :account_id, required: true
    property :description, required: true
    property :email, required: true
    property :amount, required: true
    property :currency, required: true
    property :currency_code, required: true
    property :require_confirmation, required: true
    property :started_at, from: :start_date_iso, with: ->(v){ DateTime.parse(v) if v }, required: true
    property :interval, required: true
    property :interval_code, required: true
    property :period, required: true
    property :max_periods
    property :status, required: true
    property :status_code, required: true
    property :successful_transactions, from: :successful_transactions_number, required: true
    property :failed_transactions, from: :failed_transactions_number, required: true
    property :last_transaction_at, from: :last_transaction_date_iso, with: ->(v){ DateTime.parse(v) if v }
    property :next_transaction_at, from: :next_transaction_date_iso, with: ->(v){ DateTime.parse(v) if v }

    def active?
      status == ACTIVE
    end

    def past_due?
      status == PAST_DUE
    end

    def cancelled?
      status == CANCELLED
    end

    def rejected?
      status == REJECTED
    end

    def expired?
      status == EXPIRED
    end
  end
end
