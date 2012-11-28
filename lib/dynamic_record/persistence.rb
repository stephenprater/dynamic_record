module DynamicRecord 
  module Persistence 
    def dynamic_record
      @dynamic_record || @dynamic_record = self.dematerialize
    end

    delegate :save, :save!, :delete, :destroy, :persisted?, :touch, :to => :dynamic_record

    def becomes klass
      raise Error, "Dynamic records cannot become non-dynamic" #that should crawl up the namespace and find DynamicRecord::Error
    end

    def outdated?
      @outdated
    end

    def update_attribute name, value
      name = name.to_s
      self.dynamic_record.send "#{name}=", value
      self.dynamic_record.save(:validate => false)
      self.raw_write_attribute name, value
      @outdated = true
      #fire update view
    end

    #you know what... i'm not sure what this does.
    def update_column name, value
      name = name.to_s
      self.dynamic_record.send "#{name}=", value
      self.raw_write_attribute name, value
    end

    def update_attributes attributes, options = {}
      begin
        self.update_attributes! attributes, options
      rescue ActiveRecord::RecordInvalid
        false
      end
    end

    def update_attributes! attributes, options = {}
      with_transaction_returning_status do
        self.dynamic_record.assign_attributes(attributes, options)
        self.dynamic_record.save! and (@outdated = true)
      end
    end

    def increment_with_dynamic_record attribute, by = 1
      attr = self.dynamic_record.send attribute
      attr.value ||= 0
      attr.value += by
      self.increment_without_dynamic_record(attribute,by) and (@outdate = true)
    end
    
    def decrement_with_dynamic_record attribute, by = 1
      attr = self.dynamic_record.send attribute
      attr.value ||= 0
      attr.value -= by
      self.increment_without_dynamic_record(attribute,by) and (@outdated = true)
    end

    def toggle_with_dynamic_record(attribute)
      attr = self.dynamic_record.send "#{attribute}?"
      attr.value = !attr
      self.toggle_without_dynamic_record(attribute) and (@outdated = true)
    end

    def reload
      @dynamic_record = nil
      clear_aggregation_cache
      clear_association_cache

      fresh_object = nil
      klass = DynamicRecord::Class.find(self.class.record_class_id)
      if self.outdated?
        fresh_object = klass.reify.find(self.id)
      else
        fresh_object = klass.constant.find(self.id)
      end
      @attributes.update(fresh_object.attributes)
      @outdated = false
    end

    def touch(attribute = nil)
      if not attribute
        self.dynamic_record.touch
      else
        self.dynamic_record.touch
        self.send(attribute).value == DateTime.now
      end
      @outdated = true
      true
    end

    def dematerialize
      begin
        Entity.select("`records`.*, '#{self.class.dynamic_constant_name}' as `record_class_name`")\
          .where { record_class_id == my{ self.class.record_class.id } }.find(self.id)
      rescue ::ActiveRecord::RecordNotFound
        self.class.record_class.new
      end
    end

    private
      def destroy_associations
        raise Error, "Destroy Associations doesn't make sense for DynamicRecord"
      end

      def create_or_update
        result = self.dynamic_record.new_record? ? create : update
        @outdated = true if self.result
        result != false
      end

      def update attribute_names = @attributes.keys
        with_transaction_returning_status do
          attribute_names.each do |k|
            if self.dynamic_record.send "#{k}" != @attributes[k]
              self.dynamic_record.send "#{k}=", @attributes[k]
            end
          end
          @outdated = true
        end
      end

      def create
        with_transaction_returning_status do
          new_id = self.dynamic_record.save
          self.id ||= new_id
          IdentityMap.add(self) if IdentityMap.enabled?
          self.dynamic_record.instance_eval do
            @new_record = false
          end
          self.id
          @outdated = true
        end
      end

      def attributes_from_column_definition
        self.class.record_class.field_names
      end
  end
end

