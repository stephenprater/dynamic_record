module DynamicRecord
  class DynamicRecord < ActiveRecord::Base
    #basically, it's exactly like a base only it allows
    #rountripping back to the actual dynamic:record class
    self.abstract_class = true
    @columns = []

    include Persistence 

    class << self
      attr_accessor :record_class
      delegate :dynamic_constant_name, :to => :record_class
    end
    
    alias_method_chain :toggle, :dynamic_record
    alias_method_chain :decrement, :dynamic_record
    alias_method_chain :increment, :dynamic_record

    def inspect 
      str = ["#<#{self.class.to_s} (MaterializedDynamicResource) #{ @outdated ? '(outdated)' : '' }"] 
      str << self.attributes.collect do |k,v|
       "#{k}: #{v || 'nil' }"
      end.join(", ")
      str << ">"
    end

    def is_materialized?
      true
    end

    def outdated?
      !!@outdated #coerce to bool
    end
  end
end
