FactoryGirl.define do
  factory :record_field_descriptions, :class => DynamicRecord::FieldDescription do
    factory :title do
      field_name "Title"
      field_kind "String"
      title_field true
      priority 3
    end

    factory :author do
      field_name "Author"
      field_kind "String"
      priorty 1
    end

    factory :publication_date do
      field_name "Publication Date"
      field_kind "Datetime"
      priority 2
    end

    factory :body_text do
      field_name "Body Text"
      field_kind "Text"
      priority 4
    end
  end
  
  factory :blog, :class => DynamicRecord::Class do
    name 'Blog'
    behavior_module 'BlogModule'
    field_descriptions do
      [:title, :author, :publication_date, :body_text].collect &(FactoryGirl.method :create)
    end
  end
end
