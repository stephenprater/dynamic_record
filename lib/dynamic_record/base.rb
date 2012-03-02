class DynamicRecord::Base < ActiveRecord::Base
  # only in 3.2
  #include ActiveRecord::Model
  self.abstract_class = true
  @columns = []
  config = ActiveRecord::Base.configurations["dynamic_record"] || ActiveRecord::Base.configurations[ENV["RAILS_ENV"]]
  establish_connection config
end
