class DynamicRecord::Base < ActiveRecord::Base
  abstract_class = true
  config = ActiveRecord::Base.configurations["dynamic_record"] || ActiveRecord::Base.configurations[ENV["RAILS_ENV"]]
  establish_connection config
end
