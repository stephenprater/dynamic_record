module DynamicRecord
  class Error < ::ActiveRecord::ActiveRecordError; end
  class RecordCreationError < Error; end
  class MaterializationError < Error; end
end
