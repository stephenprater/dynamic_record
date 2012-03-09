module DynamicRecord
  module Value
    autoload :Base,     'dynamic_record/value/base'
    autoload :Binary,   'dynamic_record/value/binary'
    autoload :Boolean,  'dynamic_record/value/boolean'
    autoload :DateTime, 'dynamic_record/value/date_time'
    autoload :Float,    'dynamic_record/value/float'
    autoload :Integer,  'dynamic_record/value/integer'
    autoload :Decimal,  'dynamic_record/value/decimal'
    autoload :String,   'dynamic_record/value/string'
    autoload :Text,     'dynamic_record/value/text'

    AVAILABLE_TYPES = [
      Value::Binary,
      Value::Boolean,
      Value::DateTime,
      Value::Float,
      Value::Integer,
      Value::String,
      Value::Text
    ]

    def available_types
      AVAILABLE_TYPES
    end
    module_function :available_types
  end
end
