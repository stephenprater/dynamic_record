class DynamicRecord::Entity < DynamicRecord::Base
  self.table_name = :dynamic_records

  belongs_to :record_class,
    :readonly => true,
    :foreign_key => :record_class,
    :class_name => 'DynamicRecord::Class' 

  default_scope :include => [{:fields => :value_field}, {:record_class => :field_descriptions}]

  delegate :field_names, :to => :record_class
  
  has_many :fields,
    :dependent => :destroy,
    :include => :field_description,
    :order => 'record_field_descriptions.priority ASC',
    :class_name => 'DynamicRecord::Field' do

    def of_type rfd
      self.where { record_field_description_id == prfd.id }.limit(1).first
    end

    def title
      self.joins(:record_field_description).where { record_field_description.title_field == true }.limit(1).first
    end
  end

  after_initialize :check_preloaded_record_class
  after_initialize :accessor_methods
  after_initialize :load_module

  accepts_nested_attributes_for :fields

  def inspect 
    str = ["#<#{record_class.name} (DynamicRecord) id: #{self.id || 'nil' }"]
    str << record_class.field_descriptions.collect do |f|
      meth = f.method_name
     "#{meth}: #{self.send(meth).andand.value || 'nil' }"
    end
    str.join(", ") + ">"
  end

  def record_class_name
    @attributes["record_class_name"]
  end

  def record_class_name= val
    @attributes["record_class_name"] = val
  end

  private
  def check_preloaded_record_class
    #it's likely that our record class is already loaded - if so,
    #just use the already loaded constant
    if self.record_class_name
      self.record_class = Object.const_get self.record_class_name
    end
  end

  def accessor_methods
    raise DynamicRecordCreationError, "Can't create DynamicRecord::Entity without DynamicRecord::Class" unless record_class_id
    singleton = class << self; self; end
    record_class.field_map.each_pair do |k,v|
      singleton.send :define_method, k do
        fields.detect { |i| i.record_field_description_id == v }.andand.value
      end

      singleton.send :define_method, "#{k}=" do |val|
        if field = fields.detect { |i| i.record_field_description_id == v }
          field.value = val
        else
          fd = record_class.field_descriptions.detect { |i| i.id == v }
          self.fields.build(:field_description => fd).value = val
        end
      end
    end
  end

  def load_module
    begin
      self.send :include, self.record_class.behavior_module.constantize
    rescue NameError
      # no behavior module defined
    end
  end
end
