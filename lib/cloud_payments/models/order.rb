# frozen_string_literal: true
module CloudPayments
  class Order < Model
    property :id, required: true
    property :number, required: true
    property :amount, transform_with: DecimalTransform, required: true
    property :currency, required: true
    property :currency_code, required: true
    property :email
    property :description, required: true
    property :require_confirmation, transform_with: BooleanTransform, required: true
    property :url, required: true
  end
end
