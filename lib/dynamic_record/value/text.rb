class DynamicRecord::Value::Text < ActiveRecord::Base
  include DynamicRecord::Value::Base

  serialize :value
  class << self
    def sql_type
      'TEXT'
    end
  end

end
