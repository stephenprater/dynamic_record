class DynamicRecord::Value::Datetime < ActiveRecord::Base
  include DynamicRecord::Value::Base
  class << self
    def sql_type
      'DATETIME'
    end
  end
end

