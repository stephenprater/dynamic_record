class DynamicRecord::Value::Boolean < ActiveRecord::Base
  include DynamicRecord::Value::Base
  class << self
    def sql_type
      'BOOLEAN'
    end
  end
end
