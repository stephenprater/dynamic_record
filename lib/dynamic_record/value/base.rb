module DynamicRecord 
  module Value
    module Base
      extend ActiveSupport::Concern
      
      included do
        has_one :record
      end
      
      module ClassMethods
        def to_sql 
          return @sql if @sql
          @ruby_class ||= self.to_s.underscore.split('/').last.gsub(/_/,'').intern
          @sql ||= self.connection.type_to_sql(@ruby_class)
        end

        def table_name
          self.to_s.split("::").collect { |k| k.underscore.pluralize }.join("_")
        end
      end
    end
  end
end
