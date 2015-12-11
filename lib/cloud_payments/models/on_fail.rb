module CloudPayments
  class OnFail < Model
    property :id, from: :transaction_id, required: true
    property :amount, transform_with: DecimalTransform, required: true
    property :currency, required: true
    property :invoice_id
    property :account_id
    property :subscription_id
    property :email
    property :description
    property :metadata, from: :data, default: {}
    property :date_time, transform_with: DateTimeTransform
    property :test_mode, required: true
    property :ip_address
    property :ip_country
    property :ip_city
    property :ip_region
    property :ip_district
    property :ip_lat, from: :ip_latitude
    property :ip_lng, from: :ip_longitude
    property :card_first_six, required: true
    property :card_last_four, required: true
    property :card_type, required: true
    property :card_type_code
    property :card_exp_date
    property :name
    property :issuer_bank_country
    property :status, required: true
    property :status_code
    property :reason
    property :reason_code
  end
end
