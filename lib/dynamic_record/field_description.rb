class DynamicRecord::FieldDescription < DynamicRecord::Base
  self.table_name = :dynamic_record_field_descriptions
  
  serialize :valid_choices, Array

  #should i normalize some of these empty fields into 
  #a has_many metadata thing?
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

  alias_attribute :human_attribute_name, :field_name
  
  class << self
    #leverage AR typecasting here
    def field_type_to_class fk
      case fk
      when :boolean
          Boolean
      when :string, :email, :url, :tel, :password, :search, :text, :file, :hidden, :country, :time_zone
          String
      when :integer
          Fixnum
      when :float
          Float
      when :decimal
          BigDecimal
      when :range
          Range
      when :datetime, :date, :time
          DateTime
      when :date
          Date
      when :time
          Time
      when :select, :radio, :check_boxes
          Fixnum
      when :matrix
          Hash
      end
    end

    def value_class_storage fk
      case fk
      when :boolean
          DynamicRecord::Value::Boolean 
      when :text
          DynamicRecord::Value::Text
      when :file
          DynamicRecord::Value::Binary
      when :string, :email, :url, :tel, :password, :search, :hidden, \
        :country, :time_zone, :range, :matrix
          DynamicRecord::Value::String
      when :integer, :select, :radio, :check_boxes,
          DynamicRecord::Value::Integer
      when :float
          DynamicRecord::Value::Float
      when :decimal
          DynamicRecord::Value::Decimal
      when :datetime, :date, :time
          DynamicRecord::Value::Datetime
      end
    end
  end

  def attribute_name 
    @method_name ||= self.field_name.gsub(/\s/,'').underscore
  end
  alias :method_name :attribute_name

  def sql_type
    #look this up on the connection.
    self.class.value_class_storage(self.field_kind.downcase.intern).sql_type
  end

  #validates with meta_validators
end
