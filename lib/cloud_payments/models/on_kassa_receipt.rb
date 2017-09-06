# frozen_string_literal: true
module CloudPayments
  # @see https://cloudpayments.ru/Docs/Notifications#receipt CloudPayments API
  class OnKassaReceipt < Model
    property :id, required: true
    property :document_number, required: true
    property :session_number, required: true
    property :fiscal_sign, required: true
    property :device_number, required: true
    property :reg_number, required: true
    property :inn, required: true
    property :type, required: true
    property :ofd, required: true
    property :url, required: true
    property :qr_code_url, required: true
    property :amount, transform_with: DecimalTransform, required: true
    property :date_time, transform_with: DateTimeTransform
    property :receipt
    property :invoice_id
    property :transaction_id
    property :account_id
  end
end
