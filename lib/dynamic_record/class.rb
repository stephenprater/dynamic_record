class DynamicRecord::Class < DynamicRecord::Base
  self.table_name = :dynamic_record_classes

  attr_reader :constant

  #TODO do we need a way to have references in record_classes?
  @record_value_types = [
    DynamicRecord::Value::Binary,
    DynamicRecord::Value::Boolean,
    DynamicRecord::Value::Datetime,
    DynamicRecord::Value::Float,
    DynamicRecord::Value::Integer,
    DynamicRecord::Value::String,
    DynamicRecord::Value::Text
  ]

  class << self
    attr_accessor :record_value_types
  end

  has_many :records,
    :dependent => :destroy,
    :foreign_key => :record_class_id,
    :class_name => 'DynamicRecord::Entity'

  has_many :field_descriptions,
    :foreign_key => :record_class_id,
    :dependent => :destroy,
    :class_name => 'DynamicRecord::FieldDescription',
    :order => 'priority ASC'

  before_validation :set_default_behavior_module

  def new attributes = {}
    b = records.build
    b.record_class_name = @const_name
    attributes.each_pair do |k,v|
      b.send "#{k}=", v
    end
    b
  end

  def constant
    begin
      Object.const_get self.constant_name
    rescue NameError
      raise DynamicRecord::MaterializationError, "unsaved class cannot be referenced by constant"
    end
  end

  def all
    Entity.select("`records`.*, 'Dynamic#{self.constant_name}' as `record_class_name`").where { record_class_id == my{self.id} }
  end

  def find *ids
    res = self.all.where { id.in ids }
    res.many? ? res : res.first
  end

  def human_attribute_names
    field_descriptions.collect(&:field_name)
  end

  def attribute_names 
    @field_names ||= field_descriptions.collect(&:attribute_name)
  end

  def field_map
    h = {}
    field_descriptions.collect do |fd|
      h[fd.attribute_name] = fd.id
    end
    h
  end

  def constant_name
    @const_name ||= self.name.gsub(/\s/,'')
  end

  def dynamic_constant_name
    @dyn_const ||= "Dynamic#{self.constant_name}"
  end

  def set_default_behavior_module
    if self.behavior_module.empty?
      self.behavior_module = [self.name.underscore, "module"].join("_").classify
    end
  end

  def reify(ids = nil)
    return nil if self.new_record?
    self.constant_name
    
    # call the sql which materialize a standard AR style table
    # from the EAV data
    table = self.class.connection.materialize_record(self,ids)

    record_class_id = self.id
    begin
      Object.send :remove_const, self.constant_name
      Object.send :remove_const, self.dynamic_constant_name
    rescue NameError => e
      logger.error "Couldn't remove a constant, #{e.message}"
    end


    record_class = Object.const_set self.dynamic_constant_name, self
    dynamic_record = Class.new(DynamicRecord::DynamicRecord)
    dynamic_record.instance_eval do
      self.set_table_name table_name.intern
      self.record_class = record_class
    end
    Object.const_set self.constant_name, dynamic_record
  end
  alias :materialize :reify

  accepts_nested_attributes_for :field_descriptions
end




