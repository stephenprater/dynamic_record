module DynamicRecord
  class DynamicRecordRails < Rails::Railtie
    initializer "dynamic_record.configure" do |app|
      #we can set up some config stuff here
    end

    rake_tasks do
      load 'dynamic_record/tasks/rails.tasks'
    end

    config.before_initialize do
      # support rails constant reloading
    end
  end
end
