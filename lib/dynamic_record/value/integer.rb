class DynamicRecord::Value::Integer < ActiveRecord::Base
  include DynamicRecord::Value::Base

  validates_numericality_of :value
  class << self
    def sql_type
      'INT'
    end
  end

end
