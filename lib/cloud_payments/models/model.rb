require 'bigdecimal'
require 'bigdecimal/util'

module CloudPayments
  class Model < Hashie::Trash
    include Hashie::Extensions::IgnoreUndeclared

    DateTimeTransform = ->(v) { DateTime.parse(v) if v&.respond_to? :to_s }
    DecimalTransform  = ->(v) { v&.to_d }
    IntegralTransform = ->(v) { v&.to_i }
    BooleanTransform  = ->(v) { (v == '0') ? false : !!v }
  end
end
