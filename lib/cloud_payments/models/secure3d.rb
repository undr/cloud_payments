# frozen_string_literal: true
module CloudPayments
  class Secure3D < Model
    property :transaction_id, required: true
    property :pa_req, required: true
    property :acs_url, required: true

    def id
      transaction_id
    end

    def required_secure3d?
      true
    end
  end
end
