require 'spec_helper'

describe DynamicRecord::Class do
  before do
    @blog = FactoryGirl.create :blog
  end

  it "should've create the class" do
    @blog.new_record?.should be_false
    @blog.attribute_names.should == ["title", "author", "publication_date", "body_text"]
  end

  it "should create a constant when materizalied" do
    @blog.save
    lambda { @blog.constant }.should raise_error DynamicRecord::MaterializationError
    @blog.reify
  end
end
