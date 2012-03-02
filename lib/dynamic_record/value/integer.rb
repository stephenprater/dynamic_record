class DynamicRecord::Value::Integer < ActiveRecord::Base
  include DynamicRecord::Value::Base

  validates_numericality_of :value
end
