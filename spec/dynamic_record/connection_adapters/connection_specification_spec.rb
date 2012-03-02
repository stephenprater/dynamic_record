require 'spec_helper'

describe ActiveRecord::Base::ConnectionSpecification do
  it "should have monkey patched connection specification" do
    resolver = ActiveRecord::Base::ConnectionSpecification::Resolver.new('dynamic_record_mysql2',nil)
    resolver.respond_to?(:resolve_hash_connection, true).should be_true
    resolver.respond_to?(:resolve_hash_connection_with_materialization, true).should be_true
    resolver.respond_to?(:resolve_hash_connection_without_materialization, true).should be_true
  end

  it "should include the correction module" do
    lambda do
      ActiveRecord::Base.establish_connection('dynamic_record')
    end.should_not raise_error LoadError

    lambda do
      ActiveRecord::Base.establish_connection('dynamic_record_error_db')
    end.should raise_error LoadError, 'Adapter error_db is not supported by DynamicRecord'
  end
end
