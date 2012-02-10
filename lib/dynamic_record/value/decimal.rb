class DynamicRecord::Value::Decimal < ActiveRecord::Base
  include DynamicRecord::Value::Base

  validates_numericality_of :value
  class << self
    def sql_type
      'DECIMAL'
    end
  end

end
