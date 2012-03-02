module DynamicRecord 
  module Value
    module Base
      extend ActiveSupport::Concern
      
      included do
        has_one :record
      end
      
      module ClassMethods
        def sql_type
          drv = self.to_s.underscore.split('/').last.intern
          res = self.connection.native_database_types[drv]
          raise ::TypeError, "couldn't find associted type for #{drv}" unless res
          res
        end

        def table_name
          self.to_s.split("::").collect { |k| k.underscore.pluralize }.join("_")
        end
      end
    end
  end
end
