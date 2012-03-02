module DynamicRecord
  module Value
    autoload :Base,     'dynamic_record/value/base'
    autoload :Binary,   'dynamic_record/value/binary'
    autoload :Boolean,  'dynamic_record/value/boolean'
    autoload :Datetime, 'dynamic_record/value/datetime'
    autoload :Float,    'dynamic_record/value/float'
    autoload :Integer,  'dynamic_record/value/integer'
    autoload :Decimal,  'dynamic_record/value/decimal'
    autoload :String,   'dynamic_record/value/string'
    autoload :Text,     'dynamic_record/value/text'

    def available_types
      @available_types ||= [
        Value::Binary,
        Value::Boolean,
        Value::Datetime,
        Value::Float,
        Value::Integer,
        Value::String,
        Value::Text
      ]
    end
    module_function :available_types
  end
end
