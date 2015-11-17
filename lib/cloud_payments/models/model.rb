require 'bigdecimal'
require 'bigdecimal/util'

module CloudPayments
  class Model < Hashie::Trash
    include Hashie::Extensions::IgnoreUndeclared

    DateTimeTransform  = ->(v) { DateTime.parse(v) if v }
    DecimalTransform  = ->(v) { v.to_d if v }

    BooleanTransform  =
      lambda do |v|
        if v == true || v == false || v.nil?
          v
        elsif v == '0'.freeze
          false
        elsif v == '1'.freeze
          true
        end
      end

    IntegralTransform = ->(v) { v.to_i if v }
  end
end
