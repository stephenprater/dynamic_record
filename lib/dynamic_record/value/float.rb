class DynamicRecord::Value::Float < ActiveRecord::Base
  include DynamicRecord::Value::Base

  validates_numericality_of :value
end
