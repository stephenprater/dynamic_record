class DynamicRecord::Value::Binary < ActiveRecord::Base
  include DynamicRecord::Value::Base
  class << self
    def sql_type
      'BLOB'
    end
  end
end
