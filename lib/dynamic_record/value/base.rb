module DynamicRecord 
  module Value
    module Base
      extend ActiveSupport::Concern
      
      included do
        has_one :record
      end

      module ClassMethods
        def table_name
          binding.pry
          self.to_s.split("::").collect { |k| k.underscore.pluralize }.join("_")
        end
      end
    end
  end
end
