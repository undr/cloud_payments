module CloudPayments
  class Transaction < Model
    AWAITING_AUTHENTICATION = 'AwaitingAuthentication'
    COMPLECTED = 'Completed'
    AUTHORIZED = 'Authorized'
    CANCELLED = 'Cancelled'
    DECLINED = 'Declined'

    property :id, from: :transaction_id, required: true
    property :amount, required: true
    property :currency, required: true
    property :currency_code
    property :invoice_id
    property :account_id
    property :subscription_id
    property :email
    property :description
    property :metadata, from: :json_data, default: {}
    property :date_time, transform_with: ->(v){ DateTime.parse(v) if v }
    property :created_at, from: :created_date_iso, with: ->(v){ DateTime.parse(v) if v }
    property :authorized_at, from: :auth_date_iso, with: ->(v){ DateTime.parse(v) if v }
    property :confirmed_at, from: :confirm_date_iso, with: ->(v){ DateTime.parse(v) if v }
    property :auth_code
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
    property :card_holder_message
    property :token

    def required_secure3d?
      false
    end

    def subscription
      @subscription ||= CloudPayments.client.subscriptions.find(subscription_id) if subscription_id
    end

    def card_number
      @card_number ||= "#{card_first_six}XXXXXX#{card_last_four}".gsub(/(.{4})/, '\1 ').rstrip
    end

    def ip_location
      [ip_lat, ip_lng] if ip_lng && ip_lat
    end

    def awaiting_authentication?
      status == AWAITING_AUTHENTICATION
    end

    def completed?
      status == COMPLECTED
    end

    def authorized?
      status == AUTHORIZED
    end

    def cancelled?
      status == CANCELLED
    end

    def declined?
      status == DECLINED
    end
  end
end
