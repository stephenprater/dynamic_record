require 'dynamic_record/value/base'

module DynamicRecord
  autoload :Binary,   'dynamic_record/value/binary'
  autoload :Boolean,  'dynamic_record/value/boolean'
  autoload :Datetime, 'dynamic_record/value/datetime'
  autoload :Float,    'dynamic_record/value/decimal'
  autoload :Integer,  'dynamic_record/value/float'
  autoload :Decimal,  'dynamic_record/value/integer'
  autoload :String,   'dynamic_record/value/string'
  autoload :Text,     'dynamic_record/value/text'

  module Value
    AvailableTypes = [
      DynamicRecord::Value::Binary,
      DynamicRecord::Value::Boolean,
      DynamicRecord::Value::Datetime,
      DynamicRecord::Value::Float,
      DynamicRecord::Value::Integer,
      DynamicRecord::Value::String,
      DynamicRecord::Value::Text
    ]
  end
end
