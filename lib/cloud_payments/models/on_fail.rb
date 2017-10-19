# frozen_string_literal: true
module CloudPayments
  # @see https://cloudpayments.ru/Docs/Notifications#fail CloudPayments API
  class OnFail < Model
    property :id, from: :transaction_id, required: true
    property :amount, transform_with: DecimalTransform, required: true
    property :currency, required: true
    property :date_time, transform_with: DateTimeTransform
    property :card_first_six, required: true
    property :card_last_four, required: true
    property :card_type, required: true
    property :card_exp_date, required: true
    property :test_mode, required: true
    property :reason, required: true
    property :reason_code, required: true
    property :invoice_id
    property :account_id
    property :subscription_id
    property :name
    property :email
    property :ip_address
    property :ip_country
    property :ip_city
    property :ip_region
    property :ip_district
    property :issuer
    property :issuer_bank_country
    property :description
    property :metadata, from: :data, default: {}
  end
end
