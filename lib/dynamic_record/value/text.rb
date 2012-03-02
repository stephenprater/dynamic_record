class DynamicRecord::Value::Text < ActiveRecord::Base
  include DynamicRecord::Value::Base

  serialize :value
end
