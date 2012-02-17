ActiveRecord::Schema.define(:version => 1) do
  create_table "dynamic_record_classes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "behavior_module"
  end

  create_table "dynamic_record_field_descriptions", :force => true do |t|
    t.integer  "record_class_id"
    t.string   "field_name"
    t.string   "field_kind"
    t.string   "validator"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "valid_choices"
    t.string   "css_form_class"
    t.integer  "priority"
    t.boolean  "title_field"
    t.string   "css_value_class"
    t.integer  "valid_choice_size_rows",  :default => 0
    t.integer  "valid_choice_size_cols",  :default => 0
    t.integer  "valid_choices_size_rows", :default => 0
    t.integer  "valid_choices_size_cols", :default => 0
  end

  create_table "dynamic_record_fields", :force => true do |t|
    t.integer  "record_id"
    t.integer  "record_field_description_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "value_id"
    t.string   "value_type"
  end

  create_table "dynamic_records", :force => true do |t|
    t.integer  "record_class_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "global"
  end

  create_table "dynamic_records_values_binaries", :force => true do |t|
    t.binary "value"
  end

  create_table "dynamic_records_values_booleans", :force => true do |t|
    t.boolean "value"
  end

  create_table "dynamic_records_values_datetimes", :force => true do |t|
    t.datetime "value"
  end

  create_table "dynamic_records_values_decimals", :force => true do |t|
    t.decimal "value", :precision => 10, :scale => 0
  end

  create_table "dynamic_records_values_floats", :force => true do |t|
    t.float "value"
  end

  create_table "dynamic_records_values_integers", :force => true do |t|
    t.integer "value"
  end

  create_table "dynamic_records_values_strings", :force => true do |t|
    t.string "value"
  end

  create_table "dynamic_records_values_texts", :force => true do |t|
    t.text "value"
  end
end

