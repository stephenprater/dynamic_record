class DynamicRecord::Value::String < ActiveRecord::Base
  include DynamicRecord::Value::Base
  class << self
    def sql_type
      'VARCHAR(255)'
    end
  end

end

