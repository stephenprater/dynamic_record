module DynamicRecord
  class Error < ::ActiveRecord::ActiveRecordError; end
  class RecordCreationError < Error; end
  class MaterializationError < Error; end

  autoload :Base,                 'dynamic_record/base'
  autoload :Class,                'dynamic_record/class'
  autoload :Entity,               'dynamic_record/entity'
  autoload :Field,                'dynamic_record/field'
  autoload :FieldDescription,     'dynamic_record/field_description'
  autoload :MaterializedRecord,   'dynamic_record/materialized_record'
  autoload :Value,                'dynamic_record/value'
end

require 'dynamic_record/rails' if defined? Rails
