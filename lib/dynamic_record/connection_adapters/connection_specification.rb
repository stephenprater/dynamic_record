require 'active_record/connection_adapters/abstract/connection_specification'
require 'dynamic_record/connection_adapters/abstract_adapter'
#https://github.com/rails/rails/blob/master/activerecord/lib/active_record/connection_adapters/connection_specification.rb

module ActiveRecord 
  class Base
    class ConnectionSpecification
      class Resolver
        ##
        # Patches into the connection resolver to include the database specific
        # pivot table and DDL calls.
        def resolve_hash_connection_with_materialization(spec)
          spec = spec.symbolize_keys
          begin
            require "dynamic_record/connection_adapters/#{spec[:adapter]}_adapter"
          rescue LoadError => e
            raise LoadError, "Adapter #{spec[:adapter]} is not supported by DynamicRecord"
          end
          resolve_hash_connection_without_materialization(spec)
        end
        alias_method_chain :resolve_hash_connection, :materialization
      end
    end
  end
end

