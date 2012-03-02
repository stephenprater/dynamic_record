module ActiveRecord 
  module ConnectionAdapters 
    class AbstractMysqlAdapter < AbstractAdapter
      def materialize_record(dynamic_class, ids = nil)
        super
      end
    end

    class Mysql2Adapter < AbstractMysqlAdapter 
      
      def materialize_record(dynamic_class, ids = nil)
        table_name, update_table = super

        begin
          #mysql does not suport transactional ddl, so we have to write our own
          #facility for recovering if we screw it up
          self.execute("DROP TABLE IF EXISTS `#{table_name}_new`")
          self.execute(update_table)
          self.execute("CREATE TABLE IF NOT EXISTS `#{table_name}` (dummy INT(11))")
          self.execute("DROP TABLE IF EXISTS `#{table_name}_old`")
          self.execute("RENAME TABLE `#{table_name}` TO `#{table_name + '_old'}`,`#{table_name + '_new'}` TO `#{table_name}`")
          self.execute("DROP TABLE `#{table_name + '_old'}`")
        rescue ActiveRecord::StatementInvalid => e
          self.execute("DROP TABLE IF EXISTS `#{table_name}_new`")
          self.execute("DROP TABLE IF EXISTS `#{table_name}_old")
          self.execute("DROP TABLE IF EXISTS `#{table_name}")
          raise DynamicRecord::MaterializationError, e.message
        end
        Arel::Table.new(table_name)
      end
    end
  end
end
