# frozen_string_literal: true
require 'bigdecimal'
require 'bigdecimal/util'

module CloudPayments
  class Model < Hashie::Trash
    include Hashie::Extensions::IgnoreUndeclared

    DateTimeTransform = ->(v) { DateTime.parse(v) if v && v.respond_to?(:to_s) }
    DecimalTransform  = ->(v) { v.to_d if v }
    IntegralTransform = ->(v) { v.to_i if v }
    BooleanTransform  = ->(v) { (v == '0') ? false : !!v }
  end
end
