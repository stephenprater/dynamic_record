require 'spec_helper'

describe ActiveRecord::ConnectionAdapters::AbstractAdapter do
  it "should respond to materialize record" do
    DynamicRecord::Class.connection.respond_to?(:materialize_record).should be_true
  end
  
  it "should should be implmented per adapater" do
    DynamicRecord::Class.establish_connection('dynamic_record')
    DynamicRecord::Class.connection.class.should == ActiveRecord::ConnectionAdapters::Mysql2Adapter
    DynamicRecord::Class.establish_connection('dynamic_record_postgres')
    DynamicRecord::Class.connection.class.should == ActiveRecord::ConnectionAdapters::PostgresAdapter
    DynamicRecord::Class.establish_connection('dynamic_record_sqlite3')
    DynamicRecord::Class.connection.class.should == ActiveRecord::ConnectionAdapters::Sqlite3Adapater
  end

  it "should not raise not implemented" do
    lambda { DynamicRecord::Class.connection.materialize_record(nil) }.should raise_error TypeError
  end
end

