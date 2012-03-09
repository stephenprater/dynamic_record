class DynamicRecord::Field < DynamicRecord::Base
  self.table_name = :dynamic_record_fields

  belongs_to :value_field,
    :foreign_key => :value_id,
    :foreign_type => :value_type,
    :dependent => :destroy,
    :polymorphic => true
        
  attr_accessible :value, :field_description

  belongs_to :record

  belongs_to :field_description,
    :inverse_of => :fields,
    :foreign_key => :record_field_description_id
  
  delegate :field_name, :to => :field_description

  before_save :clear_orphans
  after_initialize :set_orphan_values

  def value
    self.value_field
  end

  def value= val
    @value_type ||= self.class.value_class_storage(self.field_description.field_kind.downcase.intern)
    if self.value_field
      @orphan_values << self.value_field
    end
    self.value_field = @value_type.new(:value => val)
  end

  def read_value_from_parameter name, values_hash_from_param
    return super unless name == "value"
    return nil if values_hash_from_param.values.all?{|v|v.nil?}

    klass = self.class.field_type_to_class(self.field_kind.downcase.intern)
    
    if klass == Time
      read_time_parameter_value(name, values_hash_from_param)
    elsif klass == Date
      read_date_parameter_value(name, values_hash_from_param)
    else
      read_other_parameter_value(klass, name, values_hash_from_param)
    end
  end

  private
  def set_orphan_values
    @orphan_values = []
  end

  def clear_orphans
    @orphan_values.each do |ov|
      ov.destroy
    end
  end
end
