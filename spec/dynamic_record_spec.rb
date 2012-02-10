require 'spec_helper'

describe DynamicRecord::Class do
  before do
    @blog = FactorGirl.create :blog
  end

  it "should've create the class" do
    @blog.new_record?.should be_false
    @blog.method_names.should == [:title, :author, :publication_date, :body_text]
  end
end
