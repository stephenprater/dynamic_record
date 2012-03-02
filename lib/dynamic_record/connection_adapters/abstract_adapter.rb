module ActiveRecord
  module ConnectionAdapters
    class AbstractAdapter
      def materialize_record(dynamic_class, ids=nil)
        raise ::NotImplementedError, "abstract materialize record called" if self.class == AbstractAdapter
        
        raise TypeError, "#{dynamic_class} is not a DynamicRecord::Class" unless dynamic_class.is_a? DynamicRecord::Class
        
        table_name = dynamic_class.name.split(/\s/).map { |i| i.underscore.pluralize }.join('_')
        materialize_sql = materialize_record_sql(table_name, dynamic_class,ids)
        
        return table_name, materialize_sql
      end

      private
      def materialized_select_records ids
        @materialize_select ||= <<-SQL
          SELECT `dynamic_records`.`id` AS `id`, `dynamic_record_field_descriptions`.`field_name` as `field_name`, 
            `dynamic_record_fields`.`value_id` AS `value_id`, `dynamic_record_fields`.`value_type` AS `value_type`
          FROM `dynamic_records`
          INNER JOIN `dynamic_record_fields` ON `dynamic_record_fields`.`record_id` = `dynamic_records`.`id`
          INNER JOIN `dynamic_record_field_descriptions` ON `dynamic_record_field_descriptions`.`id` =\
          `dynamic_record_fields`.`record_field_description_id`
        SQL
        if ids
          select = @materialize_select + <<-SQL
            WHERE `record`.`id` in (#{ids.join(',')})
          SQL
        else
          @materialize_select
        end
      end 

      def materialized_view_select dynamic_class, ids = nil
        #we could do a delayed interpretation here i guess
       <<-SQL
          #{materialized_eav_sql(dynamic_class)} FROM (
            SELECT `id` AS `entity`,
            `sq`.`field_name` AS `attribute`,
            #{materialized_case_statement} FROM ( #{materialized_select_records(ids)} ) AS `sq` 
          ) AS `eav`
          GROUP BY `eav`.`entity`
        SQL
      end
      
      def materialized_eav_sql dynamic_class
        eav_sql = "SELECT `eav`.`entity` AS `id`,\n"
        eav_sql << dynamic_class.field_descriptions.collect do |fd|
          "MAX(IF(attribute = #{ActiveRecord::Base.sanitize(fd.field_name)}, `eav`.`value`, NULL))\
          AS #{ActiveRecord::Base.sanitize(fd.method_name)}"
        end.join(",\n")
      end

      #this one is memoized, since it's always the same
      def materialized_case_statement
        return @case_stmt if @case_stmt

        @case_stmt = "CASE `sq`.`value_type`\n"
        @case_stmt << DynamicRecord::Value.available_types.collect do |rvt|
          "WHEN '#{rvt.to_s}' THEN (SELECT `value` from `#{rvt.table_name}` WHERE `#{rvt.table_name}`.`id` = `sq`.`value_id`)"
        end.join("\n")
        @case_stmt << "\nEND AS `value`"
      end

      def materialize_record_sql table_name, dynamic_class, ids = nil
        
        if ids
          table_name = ActiveRecord::Base.sanitize(table_name)
          update_table = "UPDATE `#{table_name}` SET"
          update_table << field_descriptions.collect do |fd|
            "SET `#{table_name}`.#{ActiveRecord::Base.sanitize(fd.method_name)} = `new`.#{ActiveRecord::Base.sanitize(fd.method_name)}"
          end.join(",\n")
          update_table.concat <<-SQL
            FROM
              #{table_name}
            INNER JOIN
              #{materialized_view_select(dynamic_class,ids)} AS `new`
            ON
              `#{table_name}`.`id` = `new`.`id`
          SQL
        else
          #column_types
          columns = "id INT(11) PRIMARY KEY, "
          debugger
          columns << dynamic_class.field_descriptions.collect do |fd|
            "#{fd.method_name} #{fd.sql_type}"
          end.join(", ")
          update_table = "CREATE TABLE `#{table_name + '_new'}` (#{columns}) AS (#{materialized_view_select(dynamic_class,ids)})"
        end
        update_table
      end
    end
  end
end
