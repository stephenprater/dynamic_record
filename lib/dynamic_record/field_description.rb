class DynamicRecord::FieldDescription < ActiveRecord::Base
  set_table_name :dynamic_record_field_descriptions
  
  serialize :valid_choices, Array

  attr_accessible :field_name, :field_kind, :validator, 
    :valid_choices, :priority, :css_value_class, 
    :css_form_class, :title_field, :valid_choices_size_rows,
    :valid_choices_size_cols

  belongs_to :record_class,
    :foreign_key => :record_class_id,
    :class_name => "DynamicRecord::Class"
  
  
  has_many :fields,
    :foreign_key => :record_field_description_id,
    :inverse_of => :field_description,
    :class_name => "DynamicRecord::Field"

  validates :field_name, :presence => true

  def method_name
    @method_name ||= self.field_name.gsub(/\s/,'').underscore
  end

  def sql_type
    Field.value_class_storage(self.field_kind.downcase.intern).sql_type
  end

  #validates with meta_validators
end